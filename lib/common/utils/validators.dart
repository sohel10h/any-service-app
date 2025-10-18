import 'package:form_field_validator/form_field_validator.dart';

class Validators {
  /// Email Validator
  static MultiValidator email = MultiValidator([
    RequiredValidator(errorText: "Email is required"),
    EmailValidator(errorText: "Enter a valid email address"),
  ]);

  /// Phone number Validator
  static MultiValidator phoneNumber(int? length) => MultiValidator([
        RequiredValidator(errorText: "Phone number is required"),
        MinLengthValidator(length ?? 11, errorText: "Phone number must be at least ${length ?? 11} digits long"),
      ]);

  /// Password Validator
  static MultiValidator password = MultiValidator([
    RequiredValidator(errorText: "Password is required"),
    MinLengthValidator(6, errorText: "Password must be at least 6 digits long"),
  ]);

  /// Old Password Validator
  static MultiValidator oldPassword = MultiValidator([
    RequiredValidator(errorText: "Old password is required"),
    MinLengthValidator(8, errorText: "Password must be at least 8 digits long"),
  ]);

  /// Current Password Validator
  static MultiValidator currentPassword = MultiValidator([
    RequiredValidator(errorText: "Current password is required"),
    MinLengthValidator(6, errorText: "Current password must be at least 6 characters long"),
  ]);

  /// New Password Validator
  static MultiValidator newPassword = MultiValidator([
    RequiredValidator(errorText: "New password is required"),
    MinLengthValidator(6, errorText: "New password must be at least 6 characters long"),
  ]);

  /// New Password Validator
  static MultiValidator newPasswordMatch(String newPasswordValue) {
    return MultiValidator([
      RequiredValidator(errorText: "New password is required"),
      CustomMatchValidator(newPasswordValue, "Password's don't match"),
    ]);
  }

  /// Confirm Password Validator
  static MultiValidator confirmPassword(String newPasswordValue) {
    return MultiValidator([
      RequiredValidator(errorText: "Confirm password is required"),
      CustomMatchValidator(newPasswordValue, "Password's don't match"),
    ]);
  }

  /// Pin Validator
  static MultiValidator pin = MultiValidator([
    RequiredValidator(errorText: "Pin is required"),
    MinLengthValidator(8, errorText: "Pin must be at least 8 characters long"),
    PatternValidator(r'(?=.*?[#?!@$%^&*-])', errorText: "Pin must have at least one special character"),
  ]);

  /// Repeat Pin Validator
  static MultiValidator repeatPin(String pin) {
    return MultiValidator([
      RequiredValidator(errorText: "Repeat pin is required"),
      CustomMatchValidator(pin, "Pin's don't match"),
    ]);
  }

  /// OTP Validator
  static MultiValidator otp = MultiValidator([
    RequiredValidator(errorText: "OTP is required"),
    MinLengthValidator(6, errorText: "OTP must be 6 digits"),
  ]);

  /// Required Validator with Optional Field Name
  static RequiredValidator requiredWithFieldName(String? fieldName) => RequiredValidator(errorText: "${fieldName ?? "Field"} is required");

  /// Plain Required Validator
  static FieldValidator required = RequiredValidator(errorText: "Field is required");
}

class CustomMatchValidator extends TextFieldValidator {
  final String value;
  final String errorMessageText;

  CustomMatchValidator(this.value, this.errorMessageText) : super(errorMessageText);

  @override
  bool isValid(String? value) => value == this.value;
}
