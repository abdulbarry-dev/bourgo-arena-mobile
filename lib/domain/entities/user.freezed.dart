// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$User {

 String get id; String get firstName; String get lastName; String get email; String? get phone; String? get avatarUrl; int get loyaltyPoints; String? get subscriptionLevel; DateTime? get subscriptionExpiry; DateTime? get birthDate; String? get gender; String get status; String get state; bool get isParentAccount; List<ChildProfile> get children; Map<String, dynamic>? get preferences;
/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserCopyWith<User> get copyWith => _$UserCopyWithImpl<User>(this as User, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is User&&(identical(other.id, id) || other.id == id)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.loyaltyPoints, loyaltyPoints) || other.loyaltyPoints == loyaltyPoints)&&(identical(other.subscriptionLevel, subscriptionLevel) || other.subscriptionLevel == subscriptionLevel)&&(identical(other.subscriptionExpiry, subscriptionExpiry) || other.subscriptionExpiry == subscriptionExpiry)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.status, status) || other.status == status)&&(identical(other.state, state) || other.state == state)&&(identical(other.isParentAccount, isParentAccount) || other.isParentAccount == isParentAccount)&&const DeepCollectionEquality().equals(other.children, children)&&const DeepCollectionEquality().equals(other.preferences, preferences));
}


@override
int get hashCode => Object.hash(runtimeType,id,firstName,lastName,email,phone,avatarUrl,loyaltyPoints,subscriptionLevel,subscriptionExpiry,birthDate,gender,status,state,isParentAccount,const DeepCollectionEquality().hash(children),const DeepCollectionEquality().hash(preferences));

@override
String toString() {
  return 'User(id: $id, firstName: $firstName, lastName: $lastName, email: $email, phone: $phone, avatarUrl: $avatarUrl, loyaltyPoints: $loyaltyPoints, subscriptionLevel: $subscriptionLevel, subscriptionExpiry: $subscriptionExpiry, birthDate: $birthDate, gender: $gender, status: $status, state: $state, isParentAccount: $isParentAccount, children: $children, preferences: $preferences)';
}


}

/// @nodoc
abstract mixin class $UserCopyWith<$Res>  {
  factory $UserCopyWith(User value, $Res Function(User) _then) = _$UserCopyWithImpl;
@useResult
$Res call({
 String id, String firstName, String lastName, String email, String? phone, String? avatarUrl, int loyaltyPoints, String? subscriptionLevel, DateTime? subscriptionExpiry, DateTime? birthDate, String? gender, String status, String state, bool isParentAccount, List<ChildProfile> children, Map<String, dynamic>? preferences
});




}
/// @nodoc
class _$UserCopyWithImpl<$Res>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._self, this._then);

  final User _self;
  final $Res Function(User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? firstName = null,Object? lastName = null,Object? email = null,Object? phone = freezed,Object? avatarUrl = freezed,Object? loyaltyPoints = null,Object? subscriptionLevel = freezed,Object? subscriptionExpiry = freezed,Object? birthDate = freezed,Object? gender = freezed,Object? status = null,Object? state = null,Object? isParentAccount = null,Object? children = null,Object? preferences = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,loyaltyPoints: null == loyaltyPoints ? _self.loyaltyPoints : loyaltyPoints // ignore: cast_nullable_to_non_nullable
as int,subscriptionLevel: freezed == subscriptionLevel ? _self.subscriptionLevel : subscriptionLevel // ignore: cast_nullable_to_non_nullable
as String?,subscriptionExpiry: freezed == subscriptionExpiry ? _self.subscriptionExpiry : subscriptionExpiry // ignore: cast_nullable_to_non_nullable
as DateTime?,birthDate: freezed == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as DateTime?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,isParentAccount: null == isParentAccount ? _self.isParentAccount : isParentAccount // ignore: cast_nullable_to_non_nullable
as bool,children: null == children ? _self.children : children // ignore: cast_nullable_to_non_nullable
as List<ChildProfile>,preferences: freezed == preferences ? _self.preferences : preferences // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [User].
extension UserPatterns on User {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _User value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _User value)  $default,){
final _that = this;
switch (_that) {
case _User():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _User value)?  $default,){
final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String firstName,  String lastName,  String email,  String? phone,  String? avatarUrl,  int loyaltyPoints,  String? subscriptionLevel,  DateTime? subscriptionExpiry,  DateTime? birthDate,  String? gender,  String status,  String state,  bool isParentAccount,  List<ChildProfile> children,  Map<String, dynamic>? preferences)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.id,_that.firstName,_that.lastName,_that.email,_that.phone,_that.avatarUrl,_that.loyaltyPoints,_that.subscriptionLevel,_that.subscriptionExpiry,_that.birthDate,_that.gender,_that.status,_that.state,_that.isParentAccount,_that.children,_that.preferences);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String firstName,  String lastName,  String email,  String? phone,  String? avatarUrl,  int loyaltyPoints,  String? subscriptionLevel,  DateTime? subscriptionExpiry,  DateTime? birthDate,  String? gender,  String status,  String state,  bool isParentAccount,  List<ChildProfile> children,  Map<String, dynamic>? preferences)  $default,) {final _that = this;
switch (_that) {
case _User():
return $default(_that.id,_that.firstName,_that.lastName,_that.email,_that.phone,_that.avatarUrl,_that.loyaltyPoints,_that.subscriptionLevel,_that.subscriptionExpiry,_that.birthDate,_that.gender,_that.status,_that.state,_that.isParentAccount,_that.children,_that.preferences);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String firstName,  String lastName,  String email,  String? phone,  String? avatarUrl,  int loyaltyPoints,  String? subscriptionLevel,  DateTime? subscriptionExpiry,  DateTime? birthDate,  String? gender,  String status,  String state,  bool isParentAccount,  List<ChildProfile> children,  Map<String, dynamic>? preferences)?  $default,) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.id,_that.firstName,_that.lastName,_that.email,_that.phone,_that.avatarUrl,_that.loyaltyPoints,_that.subscriptionLevel,_that.subscriptionExpiry,_that.birthDate,_that.gender,_that.status,_that.state,_that.isParentAccount,_that.children,_that.preferences);case _:
  return null;

}
}

}

/// @nodoc


class _User extends User {
  const _User({required this.id, required this.firstName, required this.lastName, required this.email, this.phone, this.avatarUrl, required this.loyaltyPoints, this.subscriptionLevel, this.subscriptionExpiry, this.birthDate, this.gender, this.status = 'active', this.state = 'active', this.isParentAccount = false, final  List<ChildProfile> children = const [], final  Map<String, dynamic>? preferences}): _children = children,_preferences = preferences,super._();
  

@override final  String id;
@override final  String firstName;
@override final  String lastName;
@override final  String email;
@override final  String? phone;
@override final  String? avatarUrl;
@override final  int loyaltyPoints;
@override final  String? subscriptionLevel;
@override final  DateTime? subscriptionExpiry;
@override final  DateTime? birthDate;
@override final  String? gender;
@override@JsonKey() final  String status;
@override@JsonKey() final  String state;
@override@JsonKey() final  bool isParentAccount;
 final  List<ChildProfile> _children;
@override@JsonKey() List<ChildProfile> get children {
  if (_children is EqualUnmodifiableListView) return _children;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_children);
}

 final  Map<String, dynamic>? _preferences;
@override Map<String, dynamic>? get preferences {
  final value = _preferences;
  if (value == null) return null;
  if (_preferences is EqualUnmodifiableMapView) return _preferences;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserCopyWith<_User> get copyWith => __$UserCopyWithImpl<_User>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _User&&(identical(other.id, id) || other.id == id)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.loyaltyPoints, loyaltyPoints) || other.loyaltyPoints == loyaltyPoints)&&(identical(other.subscriptionLevel, subscriptionLevel) || other.subscriptionLevel == subscriptionLevel)&&(identical(other.subscriptionExpiry, subscriptionExpiry) || other.subscriptionExpiry == subscriptionExpiry)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.status, status) || other.status == status)&&(identical(other.state, state) || other.state == state)&&(identical(other.isParentAccount, isParentAccount) || other.isParentAccount == isParentAccount)&&const DeepCollectionEquality().equals(other._children, _children)&&const DeepCollectionEquality().equals(other._preferences, _preferences));
}


@override
int get hashCode => Object.hash(runtimeType,id,firstName,lastName,email,phone,avatarUrl,loyaltyPoints,subscriptionLevel,subscriptionExpiry,birthDate,gender,status,state,isParentAccount,const DeepCollectionEquality().hash(_children),const DeepCollectionEquality().hash(_preferences));

@override
String toString() {
  return 'User(id: $id, firstName: $firstName, lastName: $lastName, email: $email, phone: $phone, avatarUrl: $avatarUrl, loyaltyPoints: $loyaltyPoints, subscriptionLevel: $subscriptionLevel, subscriptionExpiry: $subscriptionExpiry, birthDate: $birthDate, gender: $gender, status: $status, state: $state, isParentAccount: $isParentAccount, children: $children, preferences: $preferences)';
}


}

/// @nodoc
abstract mixin class _$UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$UserCopyWith(_User value, $Res Function(_User) _then) = __$UserCopyWithImpl;
@override @useResult
$Res call({
 String id, String firstName, String lastName, String email, String? phone, String? avatarUrl, int loyaltyPoints, String? subscriptionLevel, DateTime? subscriptionExpiry, DateTime? birthDate, String? gender, String status, String state, bool isParentAccount, List<ChildProfile> children, Map<String, dynamic>? preferences
});




}
/// @nodoc
class __$UserCopyWithImpl<$Res>
    implements _$UserCopyWith<$Res> {
  __$UserCopyWithImpl(this._self, this._then);

  final _User _self;
  final $Res Function(_User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? firstName = null,Object? lastName = null,Object? email = null,Object? phone = freezed,Object? avatarUrl = freezed,Object? loyaltyPoints = null,Object? subscriptionLevel = freezed,Object? subscriptionExpiry = freezed,Object? birthDate = freezed,Object? gender = freezed,Object? status = null,Object? state = null,Object? isParentAccount = null,Object? children = null,Object? preferences = freezed,}) {
  return _then(_User(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,loyaltyPoints: null == loyaltyPoints ? _self.loyaltyPoints : loyaltyPoints // ignore: cast_nullable_to_non_nullable
as int,subscriptionLevel: freezed == subscriptionLevel ? _self.subscriptionLevel : subscriptionLevel // ignore: cast_nullable_to_non_nullable
as String?,subscriptionExpiry: freezed == subscriptionExpiry ? _self.subscriptionExpiry : subscriptionExpiry // ignore: cast_nullable_to_non_nullable
as DateTime?,birthDate: freezed == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as DateTime?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,isParentAccount: null == isParentAccount ? _self.isParentAccount : isParentAccount // ignore: cast_nullable_to_non_nullable
as bool,children: null == children ? _self._children : children // ignore: cast_nullable_to_non_nullable
as List<ChildProfile>,preferences: freezed == preferences ? _self._preferences : preferences // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

// dart format on
