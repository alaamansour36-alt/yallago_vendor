# تشغيل مشروع YallaGo على VS Code — Windows

هذا الملف يشرح تشغيل **كود Flutter** المرفق على جهاز Windows. لا تحتاج إلى Node.js أو `pnpm` لهذا المشروع؛ المطلوب هو Flutter وAndroid Studio فقط.

| المتطلب | المطلوب منك |
|---|---|
| Flutter SDK | ثبّت Flutter على Windows وأضفه إلى متغير `Path`. |
| Android Studio | ثبّت Android SDK وأنشئ Android Emulator واحدًا على الأقل. |
| VS Code | ثبّت امتدادي **Flutter** و**Dart**؛ سيقترحهما VS Code تلقائيًا من ملف `.vscode/extensions.json`. |
| جهاز تشغيل | استخدم Android Emulator أو هاتف Android حقيقي مع تفعيل USB Debugging. |

## التشغيل لأول مرة

بعد فك الضغط، افتح مجلد `yallago-flutter` نفسه في VS Code. افتح الطرفية من **Terminal → New Terminal** واكتب الأوامر التالية، من دون كتابة علامة `>` قبلها:

```powershell
flutter doctor
flutter create .
flutter pub get
flutter devices
flutter run
```

الأمر `flutter create .` مهم فقط في المرة الأولى لأنه يُنشئ مجلدات Android وiOS وWeb وWindows القياسية حول كود الواجهة الموجود بالفعل. لا يحذف `lib/main.dart` ولا الصور ولا الملفات التي تم تجهيزها لك.

> إذا ظهر في `flutter doctor` تحذير Android licences، افتح Terminal واكتب `flutter doctor --android-licenses` ثم وافق على كل البنود بـ `y`.

## التشغيل من VS Code بدل الأوامر

بعد تشغيل Android Emulator، اختر الجهاز من شريط الحالة أسفل VS Code. بعدها اضغط `F5` أو افتح **Run and Debug** واختر إعداد **YallaGo — Flutter**. أثناء تشغيل التطبيق، اضغط `r` في الطرفية لتحديث الواجهة فورًا بعد تعديل الكود، أو استخدم زر Hot Reload في VS Code.

## لو التطبيق لا يعمل

| المشكلة | الحل |
|---|---|
| `flutter is not recognized` | Flutter غير مضاف إلى `Path`. أغلق VS Code، أضف مسار `flutter\bin` إلى Path، ثم افتحه من جديد. |
| لا يوجد جهاز في `flutter devices` | افتح Emulator من Android Studio أو صِل الهاتف وفعل USB Debugging. |
| خطأ Android licenses | نفّذ `flutter doctor --android-licenses` ثم أعد `flutter doctor`. |
| أخطاء بعد تعديل الحزم | نفّذ `flutter pub get` ثم `flutter run` مرة أخرى. |

## أهم الملفات

| الملف | ما الذي تعدّله فيه؟ |
|---|---|
| `lib/main.dart` | جميع الشاشات، التنقل، النصوص، والبيانات التجريبية للعميل والمطعم. |
| `pubspec.yaml` | الحزم والصور والخطوط التي سيستخدمها التطبيق. |
| `DESIGN_TOKENS.md` | الألوان، الخطوط، المسافات، وقواعد التصميم لفريق التطوير. |
| `MVP_PLAN_ALIGNMENT.md` | ربط الشاشات الحالية بواجهات الـASP.NET Core المطلوبة لاحقًا. |

بعد التأكد من أن كل شيء يعمل، نفّذ الأمر التالي قبل إرسال أي تعديل لفريقك:

```powershell
flutter analyze
```
