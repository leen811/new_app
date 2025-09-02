# تفعيل زر تسجيل الخروج

## نظرة عامة
تم تفعيل زر تسجيل الخروج في صفحة الملف الشخصي ليعيد المستخدم لشاشة تسجيل الدخول.

## التغييرات المطبقة

### 1. إضافة Event لتسجيل الخروج
- **ملف**: `lib/Bloc/auth/auth_event.dart`
- **إضافة**: `AuthLogoutRequested` event جديد

### 2. تحديث AuthBloc
- **ملف**: `lib/Bloc/auth/auth_bloc.dart`
- **إضافة**: معالجة `AuthLogoutRequested` event
- **النتيجة**: إعادة تعيين الدور إلى `Role.guest`

### 3. تفعيل زر تسجيل الخروج
- **ملف**: `lib/Ui/Profile/profile_page.dart`
- **إضافة**: `onTap` handler لزر تسجيل الخروج
- **الوظائف**:
  - إرسال `AuthLogoutRequested` event
  - الانتقال إلى `/login` باستخدام `go_router`

## كيفية العمل

### عند الضغط على زر تسجيل الخروج:
1. **إرسال Event**: يتم إرسال `AuthLogoutRequested` إلى `AuthBloc`
2. **تحديث الحالة**: يتم تحديث `AuthState` إلى `Role.guest`
3. **الانتقال**: يتم الانتقال إلى صفحة تسجيل الدخول (`/login`)
4. **إعادة تعيين**: يتم إعادة تعيين جميع البيانات والصلاحيات

## الملفات المعدلة

### ✅ `lib/Bloc/auth/auth_event.dart`
```dart
class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}
```

### ✅ `lib/Bloc/auth/auth_bloc.dart`
```dart
on<AuthLogoutRequested>((event, emit) => 
  emit(const AuthRoleState(role: Role.guest))
);
```

### ✅ `lib/Ui/Profile/profile_page.dart`
```dart
GestureDetector(
  onTap: () {
    // تسجيل الخروج
    context.read<AuthBloc>().add(const AuthLogoutRequested());
    // العودة لشاشة تسجيل الدخول
    context.go('/login');
  },
  child: Container(
    // ... تصميم الزر
  ),
)
```

## النتيجة
الآن عند الضغط على زر "تسجيل الخروج" في صفحة الملف الشخصي:
- ✅ يتم تسجيل الخروج من النظام
- ✅ يتم إعادة تعيين الدور إلى `guest`
- ✅ يتم الانتقال تلقائياً لشاشة تسجيل الدخول
- ✅ يتم مسح جميع البيانات والصلاحيات

## ملاحظات
- الزر يستخدم `GestureDetector` للتفاعل
- يتم استخدام `go_router` للانتقال
- يتم إعادة تعيين الحالة عبر BLoC
- التصميم يبقى كما هو (أحمر مع أيقونة سهم)
