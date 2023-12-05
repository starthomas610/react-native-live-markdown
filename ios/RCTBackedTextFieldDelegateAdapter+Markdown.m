#import <react-native-markdown-text-input/RCTBackedTextFieldDelegateAdapter+Markdown.h>
#import <react-native-markdown-text-input/RCTMarkdownUtils.h>
#import <React/RCTUITextField.h>
#import <objc/message.h>

@implementation RCTBackedTextFieldDelegateAdapter (Markdown)

- (void)markdown_textFieldDidChange
{
  RCTUITextField *backedTextInputView = [self valueForKey:@"_backedTextInputView"];
  UITextRange *range = backedTextInputView.selectedTextRange;
  backedTextInputView.attributedText = [RCTMarkdownUtils parseMarkdown:backedTextInputView.attributedText.string];
  [backedTextInputView setSelectedTextRange:range notifyDelegate:YES];

  // Call the original method
  [self markdown_textFieldDidChange];
}

+ (void)load
{
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    Class cls = [self class];
    SEL originalSelector = @selector(textFieldDidChange);
    SEL swizzledSelector = @selector(markdown_textFieldDidChange);
    Method originalMethod = class_getInstanceMethod(cls, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(cls, swizzledSelector);
    method_exchangeImplementations(originalMethod, swizzledMethod);
  });
}

@end
