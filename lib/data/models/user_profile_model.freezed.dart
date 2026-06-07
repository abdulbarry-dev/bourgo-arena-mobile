// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserProfileModel {

@JsonKey(fromJson: _idFromJson) String get id;@JsonKey(name: 'first_name') String? get firstName;@JsonKey(name: 'last_name') String? get lastName; String? get name; String get email; String? get phone;@JsonKey(name: 'avatar_url') String? get avatarUrl;@JsonKey(name: 'loyalty_points') int get loyaltyPoints;@JsonKey(name: 'subscription_level') String? get subscriptionLevel;@JsonKey(name: 'subscription_expiry') DateTime? get subscriptionExpiry;@JsonKey(name: 'birth_date') DateTime? get birthDate; String? get gender; String? get status; String? get state;@JsonKey(name: 'is_parent_account') bool get isParentAccount; List<ChildProfileModel> get children; Map<String, dynamic>? get preferences;
/// Create a copy of UserProfileModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserProfileModelCopyWith<UserProfileModel> get copyWith => _$UserProfileModelCopyWithImpl<UserProfileModel>(this as UserProfileModel, _$identity);

  /// Serializes this UserProfileModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserProfileModel&&(identical(other.id, id) || other.id == id)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.loyaltyPoints, loyaltyPoints) || other.loyaltyPoints == loyaltyPoints)&&(identical(other.subscriptionLevel, subscriptionLevel) || other.subscriptionLevel == subscriptionLevel)&&(identical(other.subscriptionExpiry, subscriptionExpiry) || other.subscriptionExpiry == subscriptionExpiry)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.status, status) || other.status == status)&&(identical(other.state, state) || other.state == state)&&(identical(other.isParentAccount, isParentAccount) || other.isParentAccount == isParentAccount)&&const DeepCollectionEquality().equals(other.children, children)&&const DeepCollectionEquality().equals(other.preferences, preferences));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,firstName,lastName,name,email,phone,avatarUrl,loyaltyPoints,subscriptionLevel,subscriptionExpiry,birthDate,gender,status,state,isParentAccount,const DeepCollectionEquality().hash(children),const DeepCollectionEquality().hash(preferences));

@override
String toString() {
  return 'UserProfileModel(id: $id, firstName: $firstName, lastName: $lastName, name: $name, email: $email, phone: $phone, avatarUrl: $avatarUrl, loyaltyPoints: $loyaltyPoints, subscriptionLevel: $subscriptionLevel, subscriptionExpiry: $subscriptionExpiry, birthDate: $birthDate, gender: $gender, status: $status, state: $state, isParentAccount: $isParentAccount, children: $children, preferences: $preferences)';
}


}

/// @nodoc
abstract mixin class $UserProfileModelCopyWith<$Res>  {
  factory $UserProfileModelCopyWith(UserProfileModel value, $Res Function(UserProfileModel) _then) = _$UserProfileModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _idFromJson) String id,@JsonKey(name: 'first_name') String? firstName,@JsonKey(name: 'last_name') String? lastName, String? name, String email, String? phone,@JsonKey(name: 'avatar_url') String? avatarUrl,@JsonKey(name: 'loyalty_points') int loyaltyPoints,@JsonKey(name: 'subscription_level') String? subscriptionLevel,@JsonKey(name: 'subscription_expiry') DateTime? subscriptionExpiry,@JsonKey(name: 'birth_date') DateTime? birthDate, String? gender, String? status, String? state,@JsonKey(name: 'is_parent_account') bool isParentAccount, List<ChildProfileModel> children, Map<String, dynamic>? preferences
});




}
/// @nodoc
class _$UserProfileModelCopyWithImpl<$Res>
    implements $UserProfileModelCopyWith<$Res> {
  _$UserProfileModelCopyWithImpl(this._self, this._then);

  final UserProfileModel _self;
  final $Res Function(UserProfileModel) _then;

/// Create a copy of UserProfileModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? firstName = freezed,Object? lastName = freezed,Object? name = freezed,Object? email = null,Object? phone = freezed,Object? avatarUrl = freezed,Object? loyaltyPoints = null,Object? subscriptionLevel = freezed,Object? subscriptionExpiry = freezed,Object? birthDate = freezed,Object? gender = freezed,Object? status = freezed,Object? state = freezed,Object? isParentAccount = null,Object? children = null,Object? preferences = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,loyaltyPoints: null == loyaltyPoints ? _self.loyaltyPoints : loyaltyPoints // ignore: cast_nullable_to_non_nullable
as int,subscriptionLevel: freezed == subscriptionLevel ? _self.subscriptionLevel : subscriptionLevel // ignore: cast_nullable_to_non_nullable
as String?,subscriptionExpiry: freezed == subscriptionExpiry ? _self.subscriptionExpiry : subscriptionExpiry // ignore: cast_nullable_to_non_nullable
as DateTime?,birthDate: freezed == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as DateTime?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,state: freezed == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String?,isParentAccount: null == isParentAccount ? _self.isParentAccount : isParentAccount // ignore: cast_nullable_to_non_nullable
as bool,children: null == children ? _self.children : children // ignore: cast_nullable_to_non_nullable
as List<ChildProfileModel>,preferences: freezed == preferences ? _self.preferences : preferences // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserProfileModel].
extension UserProfileModelPatterns on UserProfileModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserProfileModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserProfileModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserProfileModel value)  $default,){
final _that = this;
switch (_that) {
case _UserProfileModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserProfileModel value)?  $default,){
final _that = this;
switch (_that) {
case _UserProfileModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _idFromJson)  String id, @JsonKey(name: 'first_name')  String? firstName, @JsonKey(name: 'last_name')  String? lastName,  String? name,  String email,  String? phone, @JsonKey(name: 'avatar_url')  String? avatarUrl, @JsonKey(name: 'loyalty_points')  int loyaltyPoints, @JsonKey(name: 'subscription_level')  String? subscriptionLevel, @JsonKey(name: 'subscription_expiry')  DateTime? subscriptionExpiry, @JsonKey(name: 'birth_date')  DateTime? birthDate,  String? gender,  String? status,  String? state, @JsonKey(name: 'is_parent_account')  bool isParentAccount,  List<ChildProfileModel> children,  Map<String, dynamic>? preferences)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserProfileModel() when $default != null:
return $default(_that.id,_that.firstName,_that.lastName,_that.name,_that.email,_that.phone,_that.avatarUrl,_that.loyaltyPoints,_that.subscriptionLevel,_that.subscriptionExpiry,_that.birthDate,_that.gender,_that.status,_that.state,_that.isParentAccount,_that.children,_that.preferences);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _idFromJson)  String id, @JsonKey(name: 'first_name')  String? firstName, @JsonKey(name: 'last_name')  String? lastName,  String? name,  String email,  String? phone, @JsonKey(name: 'avatar_url')  String? avatarUrl, @JsonKey(name: 'loyalty_points')  int loyaltyPoints, @JsonKey(name: 'subscription_level')  String? subscriptionLevel, @JsonKey(name: 'subscription_expiry')  DateTime? subscriptionExpiry, @JsonKey(name: 'birth_date')  DateTime? birthDate,  String? gender,  String? status,  String? state, @JsonKey(name: 'is_parent_account')  bool isParentAccount,  List<ChildProfileModel> children,  Map<String, dynamic>? preferences)  $default,) {final _that = this;
switch (_that) {
case _UserProfileModel():
return $default(_that.id,_that.firstName,_that.lastName,_that.name,_that.email,_that.phone,_that.avatarUrl,_that.loyaltyPoints,_that.subscriptionLevel,_that.subscriptionExpiry,_that.birthDate,_that.gender,_that.status,_that.state,_that.isParentAccount,_that.children,_that.preferences);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _idFromJson)  String id, @JsonKey(name: 'first_name')  String? firstName, @JsonKey(name: 'last_name')  String? lastName,  String? name,  String email,  String? phone, @JsonKey(name: 'avatar_url')  String? avatarUrl, @JsonKey(name: 'loyalty_points')  int loyaltyPoints, @JsonKey(name: 'subscription_level')  String? subscriptionLevel, @JsonKey(name: 'subscription_expiry')  DateTime? subscriptionExpiry, @JsonKey(name: 'birth_date')  DateTime? birthDate,  String? gender,  String? status,  String? state, @JsonKey(name: 'is_parent_account')  bool isParentAccount,  List<ChildProfileModel> children,  Map<String, dynamic>? preferences)?  $default,) {final _that = this;
switch (_that) {
case _UserProfileModel() when $default != null:
return $default(_that.id,_that.firstName,_that.lastName,_that.name,_that.email,_that.phone,_that.avatarUrl,_that.loyaltyPoints,_that.subscriptionLevel,_that.subscriptionExpiry,_that.birthDate,_that.gender,_that.status,_that.state,_that.isParentAccount,_that.children,_that.preferences);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserProfileModel implements UserProfileModel {
  const _UserProfileModel({@JsonKey(fromJson: _idFromJson) required this.id, @JsonKey(name: 'first_name') this.firstName, @JsonKey(name: 'last_name') this.lastName, this.name, required this.email, this.phone, @JsonKey(name: 'avatar_url') this.avatarUrl, @JsonKey(name: 'loyalty_points') this.loyaltyPoints = 0, @JsonKey(name: 'subscription_level') this.subscriptionLevel, @JsonKey(name: 'subscription_expiry') this.subscriptionExpiry, @JsonKey(name: 'birth_date') this.birthDate, this.gender, this.status, this.state, @JsonKey(name: 'is_parent_account') this.isParentAccount = false, final  List<ChildProfileModel> children = const [], final  Map<String, dynamic>? preferences}): _children = children,_preferences = preferences;
  factory _UserProfileModel.fromJson(Map<String, dynamic> json) => _$UserProfileModelFromJson(json);

@override@JsonKey(fromJson: _idFromJson) final  String id;
@override@JsonKey(name: 'first_name') final  String? firstName;
@override@JsonKey(name: 'last_name') final  String? lastName;
@override final  String? name;
@override final  String email;
@override final  String? phone;
@override@JsonKey(name: 'avatar_url') final  String? avatarUrl;
@override@JsonKey(name: 'loyalty_points') final  int loyaltyPoints;
@override@JsonKey(name: 'subscription_level') final  String? subscriptionLevel;
@override@JsonKey(name: 'subscription_expiry') final  DateTime? subscriptionExpiry;
@override@JsonKey(name: 'birth_date') final  DateTime? birthDate;
@override final  String? gender;
@override final  String? status;
@override final  String? state;
@override@JsonKey(name: 'is_parent_account') final  bool isParentAccount;
 final  List<ChildProfileModel> _children;
@override@JsonKey() List<ChildProfileModel> get children {
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


/// Create a copy of UserProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserProfileModelCopyWith<_UserProfileModel> get copyWith => __$UserProfileModelCopyWithImpl<_UserProfileModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserProfileModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserProfileModel&&(identical(other.id, id) || other.id == id)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.loyaltyPoints, loyaltyPoints) || other.loyaltyPoints == loyaltyPoints)&&(identical(other.subscriptionLevel, subscriptionLevel) || other.subscriptionLevel == subscriptionLevel)&&(identical(other.subscriptionExpiry, subscriptionExpiry) || other.subscriptionExpiry == subscriptionExpiry)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.status, status) || other.status == status)&&(identical(other.state, state) || other.state == state)&&(identical(other.isParentAccount, isParentAccount) || other.isParentAccount == isParentAccount)&&const DeepCollectionEquality().equals(other._children, _children)&&const DeepCollectionEquality().equals(other._preferences, _preferences));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,firstName,lastName,name,email,phone,avatarUrl,loyaltyPoints,subscriptionLevel,subscriptionExpiry,birthDate,gender,status,state,isParentAccount,const DeepCollectionEquality().hash(_children),const DeepCollectionEquality().hash(_preferences));

@override
String toString() {
  return 'UserProfileModel(id: $id, firstName: $firstName, lastName: $lastName, name: $name, email: $email, phone: $phone, avatarUrl: $avatarUrl, loyaltyPoints: $loyaltyPoints, subscriptionLevel: $subscriptionLevel, subscriptionExpiry: $subscriptionExpiry, birthDate: $birthDate, gender: $gender, status: $status, state: $state, isParentAccount: $isParentAccount, children: $children, preferences: $preferences)';
}


}

/// @nodoc
abstract mixin class _$UserProfileModelCopyWith<$Res> implements $UserProfileModelCopyWith<$Res> {
  factory _$UserProfileModelCopyWith(_UserProfileModel value, $Res Function(_UserProfileModel) _then) = __$UserProfileModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _idFromJson) String id,@JsonKey(name: 'first_name') String? firstName,@JsonKey(name: 'last_name') String? lastName, String? name, String email, String? phone,@JsonKey(name: 'avatar_url') String? avatarUrl,@JsonKey(name: 'loyalty_points') int loyaltyPoints,@JsonKey(name: 'subscription_level') String? subscriptionLevel,@JsonKey(name: 'subscription_expiry') DateTime? subscriptionExpiry,@JsonKey(name: 'birth_date') DateTime? birthDate, String? gender, String? status, String? state,@JsonKey(name: 'is_parent_account') bool isParentAccount, List<ChildProfileModel> children, Map<String, dynamic>? preferences
});




}
/// @nodoc
class __$UserProfileModelCopyWithImpl<$Res>
    implements _$UserProfileModelCopyWith<$Res> {
  __$UserProfileModelCopyWithImpl(this._self, this._then);

  final _UserProfileModel _self;
  final $Res Function(_UserProfileModel) _then;

/// Create a copy of UserProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? firstName = freezed,Object? lastName = freezed,Object? name = freezed,Object? email = null,Object? phone = freezed,Object? avatarUrl = freezed,Object? loyaltyPoints = null,Object? subscriptionLevel = freezed,Object? subscriptionExpiry = freezed,Object? birthDate = freezed,Object? gender = freezed,Object? status = freezed,Object? state = freezed,Object? isParentAccount = null,Object? children = null,Object? preferences = freezed,}) {
  return _then(_UserProfileModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,loyaltyPoints: null == loyaltyPoints ? _self.loyaltyPoints : loyaltyPoints // ignore: cast_nullable_to_non_nullable
as int,subscriptionLevel: freezed == subscriptionLevel ? _self.subscriptionLevel : subscriptionLevel // ignore: cast_nullable_to_non_nullable
as String?,subscriptionExpiry: freezed == subscriptionExpiry ? _self.subscriptionExpiry : subscriptionExpiry // ignore: cast_nullable_to_non_nullable
as DateTime?,birthDate: freezed == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as DateTime?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,state: freezed == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String?,isParentAccount: null == isParentAccount ? _self.isParentAccount : isParentAccount // ignore: cast_nullable_to_non_nullable
as bool,children: null == children ? _self._children : children // ignore: cast_nullable_to_non_nullable
as List<ChildProfileModel>,preferences: freezed == preferences ? _self._preferences : preferences // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

// dart format on
