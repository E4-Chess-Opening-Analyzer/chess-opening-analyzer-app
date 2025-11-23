import 'package:flutter/material.dart';

class GameTripleBoxes extends StatelessWidget {
  const GameTripleBoxes({
    required this.move,
    required this.whiteProb,
    required this.drawProb,
    required this.blackProb,
    super.key,
  });
  
  final String move;
  final double whiteProb;
  final double drawProb;
  final double blackProb;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    List<double> adjustNums(double double1, double double2, double double3, int threshold) { // Adjusts the three numbers so that none is below the threshold, redistributing the excess from the others
      List<double> nums = <double>[double1, double2, double3];
      List<bool> bools = <bool>[false, false, false];
      int counter = 0;

      for(int i = 0; i < nums.length; i++) {
        if (nums[i] < threshold){
          bools[i] = true;
          counter++;
        }
      }

      if(counter == 0){
        return nums;
      }
      else if(counter == 1){
        for(int i = 0; i < nums.length; i++) {
          if (bools[i]) {
            if (nums[(i+1)%3] - (threshold - nums[i])/2 < threshold){
              nums[(i+2)%3] -= (threshold - nums[i]);
              nums[i] = threshold.toDouble();
            }
            else if (nums[(i+2)%3] - (threshold - nums[i])/2 < threshold){
              nums[(i+1)%3] -= (threshold - nums[i]);
              nums[i] = threshold.toDouble();
            }
            else{
              nums[(i+1)%3] -= (threshold - nums[i])/2;
              nums[(i+2)%3] -= (threshold - nums[i])/2;
              nums[i] = threshold.toDouble();
            }
          }
        }
        return nums;
      }
      else{
        for(int i = 0; i < nums.length; i++) {
          if (!bools[i]) {
            nums[i] -= (threshold - nums[(i+1)%3]) + (threshold - nums[(i+2)%3]);
            nums[(i+1)%3] = threshold.toDouble();
            nums[(i+2)%3] = threshold.toDouble();
          }
        }
        return nums;
      }
    }
    List<double> numList = adjustNums(whiteProb * 100, drawProb * 100, blackProb * 100, 8);

    // Convert to percentages FIRST, then to integers
    int intWhiteProb = (whiteProb * 100).round(); // 0.359 → 35.9 → 36
    int intDrawProb = (drawProb * 100).round();   // 0.041 → 4.1 → 4
    int intBlackProb = (blackProb * 100).round(); // 0.600 → 60.0 → 60
    
    return Row(children: <Widget>[
      SizedBox(width: width*0.025),
      Container(
        width: width/6,
        alignment: Alignment.center,
        child: Text(move, style: const TextStyle(fontSize: 20)),
      ),
      Container(
        width: numList[0]*width/128,
        color: Colors.white,
        alignment: Alignment.center,
        child: Text('$intWhiteProb%', style: const TextStyle(fontSize: 16, color: Colors.black)),
      ),
      Container(
        width: numList[1]*width/128,
        color: Colors.grey,
        alignment: Alignment.center,
        child: Text('$intDrawProb%', style: const TextStyle(fontSize: 16, color: Colors.black)),
      ),
      Container(
        width: numList[2]*width/128,
        color: Colors.black,
        alignment: Alignment.center,
        child: Text('$intBlackProb%', style: const TextStyle(fontSize: 16, color: Colors.white)),
      ),
    ]);
  }
}
