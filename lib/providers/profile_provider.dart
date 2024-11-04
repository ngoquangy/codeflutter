import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constant/apilist.dart';
import '../constant/enum.dart';
import '../models/profile.dart';

import '../repository/profile_repository.dart';

class ProfileState {
  final Profile profile;
  final UpdateStatus updateStatus;
  final String? errorMessage; // Lưu trữ thông báo lỗi nếu có

  ProfileState({
    required this.profile,
    this.updateStatus = UpdateStatus.initial,
    this.errorMessage,
  });

  ProfileState copyWith({
    Profile? profile,
    UpdateStatus? updateStatus,
    String? errorMessage,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      updateStatus: updateStatus ?? this.updateStatus,
      errorMessage: errorMessage,
    );
  }
}

class ProfileNotifier extends StateNotifier<ProfileState> {
  final ProfileRepository _repository;

  ProfileNotifier(this._repository)
      : super(ProfileState(
            profile: Profile(
                full_name: initialProfile.full_name,
                phone: initialProfile.phone,
                address: initialProfile.address,
                photo: initialProfile.photo)));

  // ProfileNotifier(this._repository)
  //     : super(Profile(
  // full_name: initialProfile.full_name,
  // phone: initialProfile.phone,
  // address: initialProfile.address,
  // photo: initialProfile.photo));

  // Hàm để thiết lập profile ban đầu
  void setInitialProfile() {
    state = ProfileState(
        profile: Profile(
            full_name: initialProfile.full_name,
            phone: initialProfile.phone,
            address: initialProfile.address,
            photo: initialProfile.photo));
  }

  // final initialProfileProvider = FutureProvider<Profile>((ref) async {
  //   // Here, you can fetch the initial profile from a local database or API
  //   // For this example, I'm assuming the initial profile comes from an API
  //   final profileRepository = ref.read(profileRepositoryProvider);
  //   // return await profileRepository.getInitialProfile();
  //   return Profile(
  //     full_name: initialProfile.full_name,
  //     phone: initialProfile.phone,
  //     address: initialProfile.address,
  //     photo: initialProfile.photo,
  //   );
  // });

  // Cập nhật profile trong trạng thái
  //Cập nhật profile trong trạng thái
  void updatefull_name(String newfull_name) {
    state = state.copyWith(
        profile: state.profile.copyWith(full_name: newfull_name));
  }

  void updatePhone(String newPhone) {
    state = state.copyWith(profile: state.profile.copyWith(phone: newPhone));
  }

  void updateAddress(String newAddress) {
    state =
        state.copyWith(profile: state.profile.copyWith(address: newAddress));
  }

  void updateAvatar(String newphoto) {
    state = state.copyWith(profile: state.profile.copyWith(photo: newphoto));
  }

  // Gửi yêu cầu cập nhật profile lên server
  Future<void> saveProfile() async {
    try {
      // Đang cập nhật
      state = state.copyWith(updateStatus: UpdateStatus.updating);

      final isSuccess = await _repository.updateProfile(state.profile);

      if (isSuccess) {
        // Cập nhật thành công
        state = state.copyWith(updateStatus: UpdateStatus.success);
      } else {
        // Cập nhật thất bại
        state = state.copyWith(
          updateStatus: UpdateStatus.failure,
          errorMessage: 'Failed to update profile',
        );
      }
    } catch (e) {
      // Lỗi xảy ra trong quá trình cập nhật
      state = state.copyWith(
        updateStatus: UpdateStatus.failure,
        errorMessage: e.toString(),
      );
    }
  }
}

// Provider cho ProfileNotifier
final profileRepositoryProvider = Provider((ref) => ProfileRepository());

final profileProvider =
    StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  final repository = ref.watch(profileRepositoryProvider);
  return ProfileNotifier(repository);
});
