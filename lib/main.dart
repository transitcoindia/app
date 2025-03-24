import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:transit/bloc/auth_bloc/auth_bloc.dart';
import 'package:transit/bloc/auth_bloc/auth_event.dart';
import 'package:transit/bloc/auth_bloc/auth_state.dart';
import 'package:transit/bloc/autocomplete_bloc.dart/acomp_bloc.dart';
import 'package:transit/bloc/flights_bloc/flight_bloc.dart';
import 'package:transit/bloc/location_bloc/location_bloc.dart';
import 'package:transit/bloc/location_bloc/location_event.dart';
import 'package:transit/bloc/maps_bloc/maps_bloc.dart';
import 'package:transit/bloc/ride_bloc/ride_bloc.dart';
import 'package:transit/bloc/user_specific/user_bloc.dart/user_bloc.dart';
import 'package:transit/bloc/venderos_all_bloc/InDriveBloc/indrive_bloc.dart';
import 'package:transit/bloc/venderos_all_bloc/blusmart_bloc/bluesmart_bloc.dart';
import 'package:transit/bloc/venderos_all_bloc/meruBloc/meru_bloc.dart';
import 'package:transit/bloc/venderos_all_bloc/nammaYatriBloc/namma_yatri_bloc.dart';
import 'package:transit/bloc/venderos_all_bloc/olaBloc/ola_bloc.dart';
import 'package:transit/bloc/venderos_all_bloc/rapido_bloc/rapido_bloc.dart';
import 'package:transit/bloc/venderos_all_bloc/uberBloc/uber_bloc.dart';
import 'package:transit/bloc/vendors_bloc.dart/vendor_bloc.dart';
import 'package:transit/core/routes.dart';
import 'package:transit/core/theme/colors.dart';
import 'package:transit/cubits/pre_login_cubit/pre_cubit.dart';
import 'package:transit/repository/flight_repo.dart';
import 'package:transit/repository/places_repo.dart';
import 'package:transit/repository/user_repo.dart';
import 'package:transit/repository/vendors/blusmart_repo.dart';
import 'package:transit/repository/vendors/indrive_repo.dart';
import 'package:transit/repository/vendors/meru_repo.dart';
import 'package:transit/repository/vendors/namma_yatri_repo.dart';
import 'package:transit/repository/vendors/ola_repository.dart';
import 'package:transit/repository/vendors/rapido_repository.dart';
import 'package:transit/repository/vendors/uber_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> main() async {
 final widgetsBinding =  WidgetsFlutterBinding.ensureInitialized();
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky); // Hide UI bars

    // debugPrint("Phase 2");
// FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // Initialize HydratedStorage and set it as the storage for HydratedBloc
  // if(!kIsWeb ) {
  //   HydratedBloc.storage = await HydratedStorage.build(
  //   storageDirectory: await getApplicationDocumentsDirectory(),
  // );
  // }
    FlutterNativeSplash.remove();

  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(UserBloc(UserRepository()))..add(AuthCheckRequested()),
        ),
        BlocProvider(
            create: (context) => LocationBloc()
              ..add(
                RequestLocationPermission(),
              )),
        BlocProvider(
          create: (context) => FlightSearchBloc(FlightRepository()),
        ),
        
        BlocProvider(
          create: (context) => MapBloc(),
        ),
        BlocProvider(
          create: (context) => AutocompleteBloc(AutoCompleteService()),
        ),
        BlocProvider(
          create: (context) => UberBloc(UberRepository()),
        ),
        BlocProvider(
          create: (context) => MeruBloc(MeruRepository()),
        ),
        BlocProvider(
          create: (context) => BlusmartBloc(BlusmartRepo()),
        ),
        BlocProvider(
          create: (context) => IndriverBloc(IndriveRepository()),
        ),
        BlocProvider(
          create: (context) => NammaYatriBloc(NammaYatriRepository()),
        ),
        BlocProvider(
          create: (context) => OlaBloc(OlaRepository()),
        ),
        BlocProvider(
          create: (context) => RapidoBloc(RapidoRepository()),
        ),
        BlocProvider(
          create: (context) => VendorsBloc(
            UberBloc(UberRepository()),
            OlaBloc(OlaRepository()),
            RapidoBloc(RapidoRepository()),
            IndriverBloc(IndriveRepository()),
            MeruBloc(MeruRepository()),
            NammaYatriBloc(NammaYatriRepository()),
            BlusmartBloc(BlusmartRepo()),
          ),
        ),
        BlocProvider(
          create: (context) => RideBloc(),
        ),
        BlocProvider(
          create: (context) => PreLoginCubit(),
        ),
                BlocProvider(create: (context) => UserBloc(UserRepository())),

      ],
      child: BlocBuilder<AuthBloc, AuthState>(
        buildWhen: (previous, current) {
          if (current is AuthLoading || current is AuthError ) {
            debugPrint("ahksdfhsdaf");
            return false;
          } else {
            debugPrint("rebuilding");
            return true;
          }
        },
        builder: (context, state) {
          final router = createRouter(context);
          return ScreenUtilInit(
            designSize: const Size(393, 852),
            child: MaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: ThemeData(appBarTheme: AppBarTheme(backgroundColor:enabledFillColor ),
                fontFamily: 'Montserrat',
                iconTheme: const IconThemeData(color: Colors.white),
                textTheme: const TextTheme(
                    bodyLarge: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                    bodyMedium: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                colorScheme: ColorScheme.fromSeed(
                    seedColor: const Color.fromARGB(255, 3, 0, 0)),
                useMaterial3: true,
              ),
              routerConfig: router,
            ),
          );
        },
      ),
    );
  }
}
