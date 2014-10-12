var aceCodeInputBinding = new Shiny.InputBinding();
$.extend(aceCodeInputBinding, {
  find: function(scope) {
    return $(scope).find(".shiny-aceCodeInput");
  },
  getId: function(el) {
    return Shiny.InputBinding.prototype.getId.call(this, el) || el.name;
  },
  getValue: function(el) {
    return this._aceSession(el).getValue();
  },
  setValue: function(el, value) {
    this._aceSession(el).setValue(value);
  },
  subscribe: function(el, callback) {
     this._aceSession(el).on('change', callback);
  },
  unsubscribe: function(el) {
     this._aceSession(el).off('change');
  },
  receiveMessage: function(el, data) {
    if (data.hasOwnProperty('code'))
      this.setValue(el, data.code);

    if (data.hasOwnProperty('label'))
      $(el).parent().find('label[for="' + $escape(el.id) + '"]').text(data.label);
      
    if (data.hasOwnProperty('hintWords'))
      aceCode.registerHelper('hint', 'hintWords', data.hintWords);
      
    $(el).trigger('change');
  },
  initialize: function(el) {
    ace.require("ace/ext/language_tools");
    var editor = ace.edit(el);
    editor.getSession().setMode("ace/mode/r");
    editor.setOptions({
      maxLines: 15,
      enableBasicAutocompletion: true,
      enableLiveAutocompletion: true
    })
    editor.setBehavioursEnabled(true);
  },
  _aceSession: function(el) {
    return ace.edit(el).getSession();
  }
});
Shiny.inputBindings.register(aceCodeInputBinding);


var langTools = ace.require("ace/ext/language_tools");
var rlangCompleter = {
    getCompletions: function(editor, session, pos, prefix, callback) {
        //if (prefix.length === 0) { callback(null, []); return }
        var inputId = editor.container.id;
        Shiny.onInputChange('aceCode_' + inputId + '_hint', {
          linebuffer: session.getLine(pos.row),
          cursorPosition: pos.column,
          '.nonce': Math.random() // Force reactivity if lat/lng hasn't changed
        });
        this.callbacks[inputId] = callback;
    },
    //hmm...probably not right way to do it
    callbacks : {}
};
langTools.addCompleter(rlangCompleter);

Shiny.addCustomMessageHandler('aceCode', function(data) {
  var editor = ace.edit(data.inputId);
  var words = data.comps.split(/[ ,]+/).map(function(e) {
    return {name: e, value: e, meta: 'R'};
  });
  if(data.hasOwnProperty('fromList')) {
    words = words.concat(data.fromList.map(function(e) {
      return {name: e, value: e, meta: 'names'};
    }));
  }
  rlangCompleter.callbacks[data.inputId](null, words);
});