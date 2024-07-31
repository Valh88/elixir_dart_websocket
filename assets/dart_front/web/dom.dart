import 'package:web/web.dart';

class FormMessagePush {
  var forms = document.forms;

  HTMLFormElement? formButton() {
    var form = forms.item(0) as HTMLFormElement;
    return form;
  }

  HTMLInputElement input() {
    var form = formButton();
    var input = form?.querySelector('input[name="input"]') as HTMLInputElement;
    return input;
  }

  HTMLInputElement button() {
    var form = formButton();
    var button = form?.querySelector('input[name="send"]') as HTMLInputElement;
    return button;
  }
}
