var codeMirrorInputBinding = new Shiny.InputBinding();
$.extend(codeMirrorInputBinding, {
  find: function(scope) {
    return $(scope).find(".shiny-codeMirrorInput");
  },
  getId: function(el) {
    return Shiny.InputBinding.prototype.getId.call(this, el) || el.name;
  },
  getValue: function(el) {
    return el.value;
  },
  setValue: function(el, value) {
    el.value = value;
  },
  subscribe: function(el, callback) {
    el.nextSibling.CodeMirror.on('update', function(instance) {
      instance.save();
      callback(true);
    });
  },
  unsubscribe: function(el) {
    el.nextSibling.CodeMirror.off('update');
  },
  receiveMessage: function(el, data) {
    if (data.hasOwnProperty('value'))
      this.setValue(el, data.value);

    if (data.hasOwnProperty('label'))
      $(el).parent().find('label[for="' + $escape(el.id) + '"]').text(data.label);
      
    if (data.hasOwnProperty('hintWords'))
      CodeMirror.registerHelper('hint', 'hintWords', data.hintWords);
      
    $(el).trigger('change');
  },
  initialize: function(el) {
    CodeMirror.fromTextArea(el, {
      lineNumbers: true,
      matchBrackets: true,
      autoCloseBrackets: true,
      extraKeys: {'Ctrl-Space': 'autocomplete', 'Tab': 'autocomplete'}
    });
  }
});
Shiny.inputBindings.register(codeMirrorInputBinding);

CodeMirror.commands.autocomplete = function(cm) {
  Shiny.onInputChange('CodeMirror_' + cm.getTextArea().id + '_hint', {
    linebuffer: cm.getLine(cm.getCursor().line),
    cursorPosition: cm.getCursor().ch,
    '.nonce': Math.random() // Force reactivity if lat/lng hasn't changed
  });
}

Shiny.addCustomMessageHandler('codemirror', function(data) {
  var cm = $('#'+data.inputId)[0].nextSibling.CodeMirror;
  
  CodeMirror.showHint(cm, CodeMirror.hint.rShiny, data);
});

CodeMirror.registerHelper("hint", "rShiny", function(cm, options) {
    var cur = cm.getCursor(), token = cm.getTokenAt(cur);
    
    if(!token.type || !$.inArray(token.type, ['dollar'])) {
      token.start = token.end;
    }
    
    return {
      list: options.comps.split(/[ ,]+/),
      from: CodeMirror.Pos(cur.line, token.start),
            to: CodeMirror.Pos(cur.line, token.end)
    };
  });