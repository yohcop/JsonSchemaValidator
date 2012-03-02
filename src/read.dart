
#library('validator');

#import('dart:html', prefix:'html');
#import('dart:json');

#source('validator.dart');

void analyze(ev) {
  html.TextAreaElement sch = html.document.query("#schema");
  html.TextAreaElement inp = html.document.query("#input");

  var schema = JSON.parse(sch.value);
  var inj = JSON.parse(inp.value);
  validate(inj, schema);
}

main() {
  html.ButtonElement el = html.document.query("#check");
  el.on.click.add(analyze);
}

