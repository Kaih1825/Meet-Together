import 'package:flutter/cupertino.dart';
import 'package:jitsi_meet_wrapper/jitsi_meet_wrapper.dart';
import 'package:meet/screens/home_screen.dart';
import 'package:meet/utils/snackBar.dart';
import 'package:flutter/material.dart';

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
      Map<FeatureFlag, Object> featureFlags = {};

      var options = JitsiMeetingOptions(
        roomNameOrUrl: roomName,
        isAudioMuted: isAudioMuted,
        isVideoMuted: isVideoMuted,
        userDisplayName: userDisplayName,
        userAvatarUrl: photoURL,
        featureFlags: featureFlags,
      );

      await JitsiMeetWrapper.joinMeeting(
        options: options,
        listener: JitsiMeetingListener(
          onOpened: () => print("onOpened"),
          onConferenceWillJoin: (url) {
            print("onConferenceWillJoin: url: $url");
          },
          onConferenceJoined: (url) {
            print("onConferenceJoined: url: $url");
          },
          onConferenceTerminated: (url, error) {
            print("onConferenceTerminated: url: $url, error: $error");
          },
          onAudioMutedChanged: (isMuted) {
            print("onAudioMutedChanged: isMuted: $isMuted");
          },
          onVideoMutedChanged: (isMuted) {
            print("onVideoMutedChanged: isMuted: $isMuted");
          },
          onScreenShareToggled: (participantId, isSharing) {
            print(
              "onScreenShareToggled: participantId: $participantId, "
              "isSharing: $isSharing",
            );
          },
          onParticipantJoined: (email, name, role, participantId) {
            print(
              "onParticipantJoined: email: $email, name: $name, role: $role, "
              "participantId: $participantId",
            );
          },
          onParticipantLeft: (participantId) {
            print("onParticipantLeft: participantId: $participantId");
          },
          onParticipantsInfoRetrieved: (participantsInfo, requestId) {
            print(
              "onParticipantsInfoRetrieved: participantsInfo: $participantsInfo, "
              "requestId: $requestId",
            );
          },
          onChatMessageReceived: (senderId, message, isPrivate) {
            print(
              "onChatMessageReceived: senderId: $senderId, message: $message, "
              "isPrivate: $isPrivate",
            );
          },
          onChatToggled: (isOpen) => print("onChatToggled: isOpen: $isOpen"),
          onClosed: () {
            print("onClosed");
            Navigator.of(context).pushAndRemoveUntil(
                new MaterialPageRoute(builder: (context) => new home_screen()),
                (route) => route == null);
          },
        ),
      );
    } catch (error) {
      //print("error: $error");
      showSnackBar(context, error.toString());
    }
  }
}
