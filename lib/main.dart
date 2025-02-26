import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:transit/bloc/auth_bloc/auth_bloc.dart';
import 'package:transit/bloc/auth_bloc/auth_event.dart';
import 'package:transit/bloc/auth_bloc/auth_state.dart';
import 'package:transit/bloc/autocomplete_bloc.dart/acomp_bloc.dart';
import 'package:transit/bloc/location_bloc/location_bloc.dart';
import 'package:transit/bloc/location_bloc/location_event.dart';
import 'package:transit/bloc/maps_bloc/maps_bloc.dart';
import 'package:transit/bloc/ride_bloc/ride_bloc.dart';
import 'package:transit/bloc/venderos_all_bloc/InDriveBloc/indrive_bloc.dart';
import 'package:transit/bloc/venderos_all_bloc/blusmart_bloc/bluesmart_bloc.dart';
import 'package:transit/bloc/venderos_all_bloc/meruBloc/meru_bloc.dart';
import 'package:transit/bloc/venderos_all_bloc/nammaYatriBloc/namma_yatri_bloc.dart';
import 'package:transit/bloc/venderos_all_bloc/olaBloc/ola_bloc.dart';
import 'package:transit/bloc/venderos_all_bloc/rapido_bloc/rapido_bloc.dart';
import 'package:transit/bloc/venderos_all_bloc/uberBloc/uber_bloc.dart';
import 'package:transit/bloc/vendors_bloc.dart/vendor_bloc.dart';
import 'package:transit/core/routes.dart';
import 'package:transit/cubits/pre_login_cubit/pre_cubit.dart';
import 'package:transit/repository/places_repo.dart';
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
 WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize HydratedStorage and set it as the storage for HydratedBloc
  // if(!kIsWeb ) {
  //   HydratedBloc.storage = await HydratedStorage.build(
  //   storageDirectory: await getApplicationDocumentsDirectory(),
  // );
  // }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc()..add(AuthCheckRequested()),),
        BlocProvider(create: (context) => LocationBloc()..add(RequestLocationPermission(),)),
                BlocProvider(create: (context) => MapBloc(),),
                BlocProvider(create: (context) => AutocompleteBloc(AutoCompleteService()),),




                 BlocProvider(create: (context) => UberBloc(UberRepository()),),
                                  BlocProvider(create: (context) => MeruBloc(MeruRepository()),),
                                                                    BlocProvider(create: (context) => BlusmartBloc(BlusmartRepo()),),

                                  BlocProvider(create: (context) => IndriverBloc(IndriveRepository()),),

                                  BlocProvider(create: (context) => NammaYatriBloc(NammaYatriRepository()),),

                                  BlocProvider(create: (context) => OlaBloc(OlaRepository()),),

                                  BlocProvider(create: (context) => RapidoBloc(RapidoRepository()),),



                                BlocProvider(create: (context) => VendorsBloc(UberBloc(UberRepository()),OlaBloc(OlaRepository()),
                                RapidoBloc(RapidoRepository()),IndriverBloc(IndriveRepository()),MeruBloc(MeruRepository()),NammaYatriBloc(NammaYatriRepository()),
                                BlusmartBloc(BlusmartRepo()),



                                ),
                                
                                
                                ),
                                         BlocProvider(create: (context) => RideBloc(),),
                                         BlocProvider(create: (context) => PreLoginCubit(),),



      ],
      child: BlocBuilder<AuthBloc,AuthState>(
        buildWhen: (previous, current) {
          if(current is AuthLoading || current is AuthError){
            debugPrint("ahksdfhsdaf");
            return false;
          }else{
            debugPrint("rebuilding");
            return true;
          }
        },
        builder: (context, state) {
         final router = createRouter(context);
        return ScreenUtilInit(      designSize: const Size(393, 852),
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              iconTheme: const IconThemeData(color: Colors.white),
              textTheme: const TextTheme(bodyMedium: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
             
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
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

