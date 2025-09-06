import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../onboarding/domain/entities/app_preferences.dart';
import '../../../onboarding/domain/usecases/get_preferences.dart';
import '../../../onboarding/domain/usecases/save_preferences.dart';

class PreferencesState {
  final AppPreferences prefs;
  final bool loading;
  final bool saving;
  final bool saved;

  const PreferencesState({
    required this.prefs,
    required this.loading,
    required this.saving,
    required this.saved,
  });

  factory PreferencesState.initial() => const PreferencesState(
        prefs: AppPreferences.defaults,
        loading: true,
        saving: false,
        saved: false,
      );

  PreferencesState copyWith({
    AppPreferences? prefs,
    bool? loading,
    bool? saving,
    bool? saved,
  }) =>
      PreferencesState(
        prefs: prefs ?? this.prefs,
        loading: loading ?? this.loading,
        saving: saving ?? this.saving,
        saved: saved ?? this.saved,
      );
}

class PreferencesCubit extends Cubit<PreferencesState> {
  final GetPreferences getPreferences;
  final SavePreferences savePreferences;

  PreferencesCubit(this.getPreferences, this.savePreferences)
      : super(PreferencesState.initial());

  Future<void> load() async {
    emit(state.copyWith(loading: true));
    final result = await getPreferences();
    emit(state.copyWith(prefs: result, loading: false, saved: false));
  }

  void toggleDark(bool value) {
    emit(state.copyWith(
      prefs: state.prefs.copyWith(darkMode: value),
      saved: false,
    ));
  }

  void setLanguage(String code) {
    emit(state.copyWith(
      prefs: state.prefs.copyWith(languageCode: code),
      saved: false,
    ));
  }

  void setSaveChat(bool value) {
    emit(state.copyWith(
      prefs: state.prefs.copyWith(saveChat: value),
      saved: false,
    ));
  }

  Future<void> persist() async {
    emit(state.copyWith(saving: true));
    await savePreferences(state.prefs);
    emit(state.copyWith(saving: false, saved: true));
  }
}