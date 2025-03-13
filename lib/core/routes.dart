import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:transit/bloc/auth_bloc/auth_bloc.dart';
import 'package:transit/bloc/auth_bloc/auth_state.dart';
import 'package:transit/screens/auth_screens/login_page.dart';
import 'package:transit/screens/auth_screens/ots_screen.dart';
import 'package:transit/screens/auth_screens/register_page.dart';
import 'package:transit/screens/auth_screens/sign_up_screen.dart';
import 'package:transit/screens/cabs/cabs_home.dart';
import 'package:transit/screens/home_screens/home_screen.dart';
import 'package:transit/screens/home_screens/list_page.dart';
import 'package:transit/screens/home_screens/maps_page.dart';
import 'package:transit/screens/home_screens/to_from_page.dart';
import 'package:transit/screens/misc/about_us_page.dart';
import 'package:transit/screens/misc/contact_us_page.dart';
import 'package:transit/screens/pre_login_screens/login_type_page.dart';
import 'package:transit/screens/pre_login_screens/pre_login_screen.dart';
import 'package:transit/screens/ride_duration/ride_init.dart';
import 'package:transit/screens/rides/your_rides.dart';
import 'package:transit/screens/second_maps_page.dart';
import 'package:transit/screens/type_specific/flight_home.dart';
import 'package:transit/screens/user_screens/profile_screen.dart';
bool isAuthenticated = true;

GoRouter createRouter(BuildContext context) {
  final authBloc = BlocProvider.of<AuthBloc>(context);
return GoRouter(
  

  initialLocation:(authBloc.state is AuthAuthenticated)?'/home':'/preLogin',
 refreshListenable: GoRouterRefreshStream(
  context.read<AuthBloc>().stream.where((state) =>
    state is AuthAuthenticated || state is AuthUnauthenticated),
),

  redirect: (context, state) {
    // if (authBloc.state is AuthUnauthenticated && (state.matchedLocation != '/login' && state.matchedLocation != '/register'
    // && state.matchedLocation != '/loginType'  && state.matchedLocation != '/signUp'
    // )) {
    //   return '/preLogin';
    // } 
    //   else if (authBloc.state is WaitforOtp ) {
    //   debugPrint("rerouting here to OTP");
    //   return '/otp';
    // }
    // else if (authBloc.state is AuthError){
    //   return null;
    // }
    // else if (authBloc.state is AuthAuthenticated && state.matchedLocation == '/login') {
    //   return '/home';
    // }

   return null;
    // // Redirect to home if authenticated and trying to access login page
    // if (authState is AuthAuthenticated && state.fullPath == '/login') {
    //   return '/';
    // }

   //return null; // No redirection needed if the state matches the desired route.
  },
  routes: [
    GoRoute(
      path: '/home',
      builder: (context, state) =>  HomeScreen(),
      
      
    ),
    GoRoute(
      path: '/page1',
      builder: (context, state) =>  MapsPage(),
    ),
     GoRoute(
      path: '/signUp',
      builder: (context, state) =>  SignUpScreen(type: 'email',),
    ),
    GoRoute(
      path: '/page2',
      builder: (context, state) => const ListOfRidesPage(),
    ),
    GoRoute(
      path: '/page3',
      builder: (context, state) =>  RidePage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) =>  LoginPage(),
    ),
    GoRoute(
      path: '/loginType',
      builder: (context, state) =>  LoginTypePage(),
    ),
    GoRoute(
      path: '/cabs',
      builder: (context, state) =>  CabsHome(),
    ),
    GoRoute(
      path: '/flights',
      builder: (context, state) =>  FlightHome(),
    ),
    GoRoute(
      path: '/preLogin',
      builder: (context, state) =>  PreLoginScreen(),
    ),
     GoRoute(
      path: '/register',
      builder: (context, state) =>  RegisterPage(),
    ),
    GoRoute(
      path: '/contact-us',
      builder: (context, state) =>  ContactUsPage(),
    ),
    GoRoute(
      path: '/about-us',
      builder: (context, state) =>  const AboutUsPage(),
    ),
     GoRoute(
      path: '/privacy-policy',
      builder: (context, state) =>  const AboutUsPage(),
      // TODO: Make the privacy policy page 
    ),
    GoRoute(
      path: '/maps-2',
      builder: (context, state) =>  SecondMapsPage(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) =>  const ProfileScreen(),
    ),
     GoRoute(
      path: '/your-rides',//rideInitiated
      builder: (context, state) =>  YourRides(),
    ),
    GoRoute(
      path: '/rideInitiated',//rideInitiated
      builder: (context, state) =>  RideInitiatedOTP(),
    ),
  ],
);}



class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {

    stream.listen((_) => notifyListeners());
  }
}