import 'package:flutter/material.dart';
import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';
import 'package:meet/utils/snackBar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JitsiMeetMethous {
  void joinMeeting({
    required String roomName,
    required String userDisplayName,
    required String photoURL,
    required bool isAudioMuted,
    required bool isVideoMuted,
    required BuildContext context,
  }) async {
    try {
      // Map<FeatureFlag, Object> featureFlags = {};
      //
      var options = JitsiMeetConferenceOptions(
        serverURL: "https://meet.skailine.net",
        room: roomName,
        configOverrides: {
          "startWithAudioMuted": isAudioMuted,
          "startWithVideoMuted": isVideoMuted,
        },
        featureFlags: {
          "prejoinpage.enabled": false,
        },
        userInfo: JitsiMeetUserInfo(
          displayName: userDisplayName,
          avatar: photoURL,
        ),

        // featureFlags: featureFlags,
      );

      var jitsiMeet = JitsiMeet();
      jitsiMeet.join(options, JitsiMeetEventListener(conferenceTerminated: (url, error) async {
        Navigator.restorablePushNamedAndRemoveUntil(context, "/home", (route) => false);
        SharedPreferences sp = await SharedPreferences.getInstance();
        sp.setString("recentMeet", roomName);
        if (error != null) {
          debugPrint("conferenceJoined: error: $error");
        }
      }));
    } catch (error) {
      //print("error: $error");
      showSnackBar(context, error.toString());
    }
  }
}
