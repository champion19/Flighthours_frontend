# Changes in `pilot_info_page.dart`

I have updated the `pilot_info_page.dart` file to replace a `TextFormField` with a `CheckboxListTile` for the "vigente" field.

## Summary of Changes:

1.  **Replaced `TextFormField` with `CheckboxListTile`**: The text input for "vigente" has been changed to a more user-friendly checkbox.
2.  **State Management**:
    *   Removed `_vigenteController` and its `dispose` method.
    *   Added a new boolean state variable `_vigente` to manage the checkbox state.
3.  **Submit Logic**: The `_submit` method was updated to handle the boolean value from the `_vigente` checkbox. It now sends "si" or "no" to the `EnterPilotInformation` event based on the checkbox's value.

These changes improve the user experience by providing a clearer and more intuitive way to input the "vigente" status.
