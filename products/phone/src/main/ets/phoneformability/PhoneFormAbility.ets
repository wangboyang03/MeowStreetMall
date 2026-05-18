import { formBindingData, FormExtensionAbility, formInfo } from '@kit.FormKit';
import { Want } from '@kit.AbilityKit';

export default class PhoneFormAbility extends FormExtensionAbility {
  onAddForm(want: Want) {
    // Called to return a FormBindingData object.
    const formData: Record<string, string> = {
      "formId": want.parameters!["ohos.extra.param.key.form_identity"] as string
    };
    return formBindingData.createFormBindingData(formData); // 从formAbility到卡片
  }

  onCastToNormalForm(formId: string) {
    // Called when the form provider is notified that a temporary form is successfully
    // converted to a normal form.
  }

  onUpdateForm(formId: string) {
    // Called to notify the form provider to update a specified form.
  }

  onFormEvent(formId: string, message: string) {
    // Called when a specified message event defined by the form provider is triggered.
  }

  onRemoveForm(formId: string) {
    // Called to notify the form provider that a specified form has been destroyed.
  }

  onAcquireFormState(want: Want) {
    // Called to return a {@link FormState} object.
    return formInfo.FormState.READY;
  }
}