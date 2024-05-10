import 'package:flutter/material.dart';
import 'package:flutter_application_2/app_details/color.dart';
import 'package:flutter_application_2/app_details/const.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import '../../../../class/class.dart';

class VoiceCall extends StatefulWidget {
  const VoiceCall({super.key, required this.id});
  final String id;

  @override
  State<VoiceCall> createState() => _VoiceCallState();
}

class _VoiceCallState extends State<VoiceCall> {
  String userCallId = '';
  @override
  void initState() {
    print(
        'zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz92fqSx7HDYcdh4wbXA5JyuRl1PNOp8WZsCBkLVvUrnIieaQmFE');
    onUserLogin();
    // TODO: implement initState

    ;
    super.initState();
  }

  void onUserLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = await prefs.get(
      'user_id',
    );

    setState(() {
      userCallId = userId.toString();
    });
    print(userId);
    print('ssssssssssssssssssssssssssssssssssssssssss');
    ZegoUIKitPrebuiltCallInvitationService().send(callID:'' ,
        resourceID: 'zego_call',
        notificationMessage: 'helo koombiyo app calling you',
        notificationTitle: 'sssssssssssssssssssssss',
        customData: 'xxxxxxxxxxxxxxxxxx',
        invitees: [ZegoCallUser('10', '10')],
        isVideoCall: false);
    ZegoSendCallInvitationButton(
      isVideoCall: false,
      invitees: [ZegoUIKitUser(id: '10', name: '10')],
      // 'resourceID' needs to be the same as the 'resourceID' configured in your console.
      resourceID: 'zego_call',
      // ...
    );
  }

  back(String text) async {
    await notification().warning(context, text);
    Navigator.pop(context);
    print(
        'wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww');
  }

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID:
          appId, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
      appSign:
          signId, // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
      userID: userCallId.toString(),
      userName: userCallId.toString(),
      callID: '12',
      plugins: [ZegoUIKitSignalingPlugin()],
      onDispose: () {
        print(
            'qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqfffffffffffffffqqqqqqqqqqqqqq');
      },
      events: ZegoUIKitPrebuiltCallEvents(
          user: ZegoCallUserEvents(
        onLeave: (p0) {
          print(p0);
          print('dddddddddddddddddddddddddddddddddddddddddddddd');
        },
        onEnter: (value) {
          print(value);
          print(
              'qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq');
        },
      )),
      // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
    );

    // return ZegoUIKitPrebuiltCall(
    //   events: ZegoUIKitPrebuiltCallEvents(
    //     onError: (p0) {
    //       print(p0);
    //     },
    //   ),
    //   plugins: [ZegoUIKitSignalingPlugin()],
    //   appID:
    //       appId, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
    //   appSign:
    //       signId, // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
    //   userID: widget.usrId,
    //   userName: widget.usrId,
    //   callID: '100',
    //   // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
    //   config: ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall()
    //     ..avatarBuilder = (BuildContext context, Size size, ZegoUIKitUser? user,
    //         Map extraInfo) {
    //       return user != null
    //           ? Container(
    //               decoration: BoxDecoration(
    //                 shape: BoxShape.circle,
    //                 image: DecorationImage(
    //                   image: NetworkImage(
    //                     'https://media.gettyimages.com/id/665146638/vector/social-media-communication.jpg?s=1024x1024&w=gi&k=20&c=UFmJAlfRmPeDbIWAWfEeveI5NENaVtq6mJDU4W8jm2k=',
    //                   ),
    //                 ),
    //               ),
    //             )
    //           : const SizedBox();
    //     },
    // );
  }
}

// ZegoSendCallInvitationButton(
//    isVideoCall: true,
//    //You need to use the resourceID that you created in the subsequent steps.
//    //Please continue reading this document.
//    resourceID: "zegouikit_call",
//    invitees: [
//       ZegoUIKitUser(
//          id: targetUserID,
//          name: targetUserName,
//       ),
//       ...
//       ZegoUIKitUser(
//          id: targetUserID,
//          name: targetUserName,
//       )
//    ],
// )

class CallInvite extends StatelessWidget {
  const CallInvite({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
