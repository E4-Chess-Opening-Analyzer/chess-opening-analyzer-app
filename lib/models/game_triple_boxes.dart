import 'package:flutter/material.dart';

class GameTripleBoxes extends StatelessWidget {
  final String move;
  final double whiteProb;
  final double drawProb;
  final double blackProb;

  const GameTripleBoxes({super.key, required this.move, required this.whiteProb, required this.drawProb, required this.blackProb});

  

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    List adjustNums(double double1, double double2, double double3, int threshold) { // Adjusts the three numbers so that none is below the threshold, redistributing the excess from the others
      List nums = [double1, double2, double3];
      List bools = [false, false, false];
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
          if (bools[i] == true) {
            if (nums[(i+1)%3] - (threshold - nums[i])/2 < threshold){
              nums[(i+2)%3] -= (threshold - nums[i]);
              nums[i] = threshold;
            }
            else if (nums[(i+2)%3] - (threshold - nums[i])/2 < threshold){
              nums[(i+1)%3] -= (threshold - nums[i]);
              nums[i] = threshold;
            }
            else{
              nums[(i+1)%3] -= (threshold - nums[i])/2;
              nums[(i+2)%3] -= (threshold - nums[i])/2;
              nums[i] = threshold;
            }
          }
        }
        return nums;
      }
      else{
        for(int i = 0; i < nums.length; i++) {
          if (bools[i] == false) {
            nums[i] -= (threshold - nums[(i+1)%3]) + (threshold - nums[(i+2)%3]);
            nums[(i+1)%3] = threshold;
            nums[(i+2)%3] = threshold;
          }
        }
        return nums;
      }
    }
    List numList = adjustNums(whiteProb, drawProb, blackProb, 8);
    print(numList);

    int intWhiteProb = whiteProb.toInt();
    int intDrawProb = drawProb.toInt();
    int intBlackProb = blackProb.toInt();
    
    return Row(children: [
      SizedBox(width: width*0.025),
      Container(
        width: width/6,
        alignment: Alignment.center,
        child: Text(move, style: TextStyle(fontSize: 20)),
      ),
      Container(
        width: numList[0]*width/128,
        color: Colors.white,
        alignment: Alignment.center,
        child: Text('$intWhiteProb%', style: TextStyle(fontSize: 16, color: Colors.black)),
      ),
      Container(
        width: numList[1]*width/128,
        color: Colors.grey,
        alignment: Alignment.center,
        child: Text('$intDrawProb%', style: TextStyle(fontSize: 16, color: Colors.black)),
      ),
      Container(
        width: numList[2]*width/128,
        color: Colors.black,
        alignment: Alignment.center,
        child: Text('$intBlackProb%', style: TextStyle(fontSize: 16, color: Colors.white)),
      ),
    ]);
  }
}