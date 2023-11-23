import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart' as firebase_ui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:retro_bank_app/core/common/views/page_under_construction_view.dart';
import 'package:retro_bank_app/core/extensions/context_extension.dart';
import 'package:retro_bank_app/core/services/injection_container/injection_container.dart';
import 'package:retro_bank_app/core/utils/constants.dart';
import 'package:retro_bank_app/src/auth/data/models/local_user_model.dart';
import 'package:retro_bank_app/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:retro_bank_app/src/auth/presentation/views/sign_in_screen.dart';
import 'package:retro_bank_app/src/auth/presentation/views/sign_up_screen.dart';
import 'package:retro_bank_app/src/dashboard/presentation/dashboard_screen.dart';
import 'package:retro_bank_app/src/on_boarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:retro_bank_app/src/on_boarding/presentation/views/on_boarding_screen.dart';
import 'package:retro_bank_app/src/transactions/presentation/bloc/transactions_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'router_main.dart';
