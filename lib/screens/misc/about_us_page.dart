import 'package:flutter/material.dart';
import 'package:transit/core/theme/colors.dart';
import 'package:transit/core/widgets/bar_chart.dart';
import 'package:transit/core/widgets/circle_drawing.dart';
import 'package:transit/core/widgets/line_graph.dart';
import 'package:transit/core/widgets/safe_scaffold.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeScaffold(
      appBar: AppBar(
        
        backgroundColor: transparent,
        leading: IconButton(onPressed: (){Navigator.of(context).pop();}, icon: Icon(Icons.arrow_back, color: white,)),
       // title: Text("About us", style: TextStyle(color: white),)
        ),
      body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: const Color.fromARGB(78, 109, 113, 121),borderRadius: BorderRadius.circular(8)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            const Text("About us",style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),),
            const Text("Welcome to Transit, the one-stop platform for comparing rides across major cab providers. Our mission is to empower users with information and transparency, helping you find the most cost-effective, convenient rides that suit your needs.", style: TextStyle(fontSize: 16),),
            const CircularProgress(),
            const Text("Our Vision",style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),),
            const Text("We aim to make ride choices easier and more transparent for users in today's fast-paced world. Our platform ensures accessibility and reliability.", style: TextStyle(fontSize: 16)),
            const LineGraph(),
            const Text("Why Choose Us?",style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),),
            const Text("Transparency: Real-time information from trusted cab services.Simplicity: User-friendly interface to streamline decision-making.Efficiency: Instant access to fare and availability details.", style: TextStyle(fontSize: 16)),
            const BarChart(),
            const SizedBox(height: 20,),
              const Text("Contact Us",style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),),
            const Text("Have questions or feedback? We'd love to hear from you ! Reach out via our Contact Us page", style: TextStyle(fontSize: 16)),
        
                        Image.asset('assets/images/aboutus.png',),
        
          ],),
        ),
      ),
    ),);
  }
}