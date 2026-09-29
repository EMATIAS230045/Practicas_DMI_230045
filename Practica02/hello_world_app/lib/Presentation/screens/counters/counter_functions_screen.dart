import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

class CounterFunctionsScreen extends StatefulWidget {
  const CounterFunctionsScreen({super.key});

  @override
  State<CounterFunctionsScreen> createState() => _CounterFunctionsScreenState();
}

class _CounterFunctionsScreenState extends State<CounterFunctionsScreen> {
  int clickCounter = 0;

  @override
  Widget build(BuildContext context) {
    // Evaluamos el color según el valor actual del contador
    Color counterColor = Colors.blue;
    if (clickCounter > 0) counterColor = Colors.green;
    if (clickCounter < 0) counterColor = Colors.red;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Counter Functions Mati',
          style: GoogleFonts.workSans(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              setState(() {
                clickCounter = 0;
              });
            }, 
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$clickCounter',
              style: GoogleFonts.workSans( 
                fontSize: 160, 
                fontWeight: FontWeight.w100,
                color: counterColor,
              ),
            ),
            Text(
              'Click${clickCounter == 1 ? '' : 's'}', 
              style: GoogleFonts.workSans(fontSize: 25),
            )
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CustomButtom(icon: Icons.plus_one,
          onPressed: (){
            clickCounter ++;
            setState(() {});
          }),
          const SizedBox(height: 15),
          CustomButtom(icon: Icons.exposure_minus_1_outlined,onPressed: (){
            clickCounter --;
            setState(() {});
          }),
          const SizedBox(height: 15),
          CustomButtom(icon: Icons.refresh_outlined,
          onPressed: (){
            clickCounter = 0;
            setState(() {});
          }),
          const SizedBox(height: 15),

          // FloatingActionButton(
          //   shape: const StadiumBorder(),
          //   onPressed: () {},
          //   child: const Icon(Icons.exposure_minus_1_outlined),
          // ),
          
          // const SizedBox(height: 15),

          // FloatingActionButton(
          //   shape: const StadiumBorder(),
          //   onPressed: () {
          //     clickCounter = 0;
          //     setState(() {});
          //   },
          //   child: const Icon(Icons.refresh_outlined),
          // ),
          
        ],
      ),
    );
  }
}

class CustomButtom extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const CustomButtom({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 10,
      onPressed: () {
        // 1. Sonido de clic del sistema
        SystemSound.play(SystemSoundType.click);

        // 2. Vibración directa del hardware
        HapticFeedback.vibrate(); 

        // 3. Ejecuta la función del botón (sumar, restar, etc.)
        if (onPressed != null) onPressed!();
      },
      child: Icon(icon),
    );
  }
}
//+
//clickCounter++;
//setState(() {});
//-
//clickCounter--;
              //setState(() {});

