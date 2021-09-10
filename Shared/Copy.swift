import Foundation

enum Copy {
    static let notifications = """
We use notifications to display important messages and provide feedback to your actions, and only when you are actively using the app.

We will never send Push Notifications.

Your privacy is respected at all times.
"""
    
    static let privacy = """
This app is **not** tracking you in anyway, nor sharing any information from you with no one, we are also not storing any data concerning you.

We make use of Apple's *iCloud* to synchronise your data across your own devices, but no one other than you, not us nor even Apple can access your data.

If you allow **notifications** these are going to be displayed only for giving feedback on actions you take while using the app, we **don't** want to contact you in anyway and specifically we **don't** want to send you **Push Notifications**.

Whatever you do with this app is up to you and we **don't** want to know about it.
"""
    
    static let terms = """
The technologies we use to protect your data are some of the best in the industry:
— Apple's iCloud
— Apple's Keychain
— Apple's Face ID
— AES-GCM

We do our best to protect the information you store in this app, however we are a very small independent team and we can't commit to provide the maximum state of the art digital security.

Anything you decide to store in the app, meaning every *secret* that you add to this app, you are doing it under your own responsibility. We will do our best so that no one can have access to it, not even us, however, we can't commit to protect your information against an unlikely breach of security.

For these reasons, we recommend to avoid using this app to store sensitive information, for example:

— Do **not** store passwords
— Do **not** store credit card information
— Do **not** store any other sensitive information

When you add a *secret* on this app it gets encrypted with a *symmetric key* and stored both locally and on a *public database* on iCloud.

It is stored on the *public database* so that it doesn't affect your own's account iCloud quota. Instead we take care of the quota for you, we pay for this storage so that you don't have to pay for it with your account.

Even though it is stored in a *public database*, **no one else but you can read or access your secrets**, not even apple, not even us, that is because it is stored with security rules enforcing only the owner of a secret to access it.

The *symmetric key* is stored in your own *Keychain*, so that only you have access to it, across all your devices, and you can decrypt your data and access your own secrets.

The data stored locally is protected by the operative system's *sandbox*, meaning no other app but this app can access it, and also it is protected with the same encyption.

By using this app you are accepting these terms.
"""
    
    static let markdown = """
You can format your secrets using **Markdown**.

**— Bold**
Use 2 * to make a text bold.
For example `**hello**` will be: **hello**.

**— Italic**
Use 1 _ to make a text italic.
For example `_hello_` will be: _hello_.

**— Strikethrough**
Use 2 ~ to make a text strikethrough.
For example `~~hello~~` will be: ~~hello~~.

**— Monospaced**
Use 1 \\` to make a text monospaced, otherwise also known as code voice.
For example \\`hello\\` will be: `hello`.

**— Combine**
You can combine styles.
For example `**_hello_**` will be: **_hello_**.

**— Links**
You can add hyperlinks in your text, add a description text between [ and ], followed by the URL inside ( and ).
\\[Wikipedia](https://wikipedia.org) will be: [Wikipedia](https://wikipedia.org).

[Learn more](https://en.wikipedia.org/wiki/Markdown)
"""
}
