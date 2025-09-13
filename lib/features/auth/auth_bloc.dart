import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthBloc() : super(AuthInitial()) {
    on<AuthCheckRequested>(_onCheck);
    on<AuthRegisterRequested>(_onRegister);
    on<AuthLoginRequested>(_onLogin);
    on<AuthLogoutRequested>(_onLogout);
  }

  void _onCheck(_, Emitter<AuthState> emit) {
    emit(_auth.currentUser == null ? AuthUnauthenticated() : AuthAuthenticated());
  }

  Future<void> _onRegister(AuthRegisterRequested e, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _auth.createUserWithEmailAndPassword(email: e.email, password: e.password);
      emit(AuthAuthenticated());
    } catch (err) {
      emit(AuthError(err.toString()));
    }
  }

  Future<void> _onLogin(AuthLoginRequested e, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _auth.signInWithEmailAndPassword(email: e.email, password: e.password);
      emit(AuthAuthenticated());
    } catch (err) {
      emit(AuthError(err.toString()));
    }
  }

  Future<void> _onLogout(_, Emitter<AuthState> emit) async {
    await _auth.signOut();
    emit(AuthUnauthenticated());
  }
}