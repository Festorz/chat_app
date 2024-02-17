import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/size_util.dart';
import '../../widgets/apptext.dart';
import '../../widgets/boldtext.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with WidgetsBindingObserver {
  final TextEditingController _messageController = TextEditingController();
  final itemScrollController = ItemScrollController();

  late PreviousMessageListQuery query;

  bool loading = true;

  String title = 'Chat App';
  String userId = '';

  bool hasPrevious = false;
  List<BaseMessage> messageList = [];
  int? participantCount;

  OpenChannel? openChannel;

  MessageCollection? collection;

  final String channelUrl =
      'sendbird_open_channel_14092_bf4075fbb8f12dc0df3ccc5c653f027186ac9211';

  String message = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _getUser();

    SendbirdChat.addChannelHandler('OpenChannel', MyOpenChannelHandler(this));
    SendbirdChat.addConnectionHandler('OpenChannel', MyConnectionHandler(this));

    OpenChannel.getChannel(channelUrl).then((openChannel) {
      this.openChannel = openChannel;

      openChannel.enter().then((_) => _initialize());
    });
  }

  void _initialize() {
    OpenChannel.getChannel(channelUrl).then((openChannel) {
      query = PreviousMessageListQuery(
        channelType: ChannelType.open,
        channelUrl: channelUrl,
      )..next().then((messages) {
          setState(() {
            messageList
              ..clear()
              ..addAll(messages);
            loading = false;

            title = openChannel.name;
            hasPrevious = query.hasNext;
            participantCount = openChannel.participantCount;
          });
        });
    });
  }

  void _getUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      userId = (preferences.getString('userID') ?? '');
    });
  }

  @override
  Widget build(BuildContext context) {
    Color white = Colors.white;
    Color black = Colors.black;
    Color pink = Colors.pink;

    double w = mediaQueryData.size.width;
    double h = mediaQueryData.size.height;

    return Scaffold(
      backgroundColor: black,
      appBar: AppBar(
        backgroundColor: black,
        leading: Icon(
          Icons.arrow_back_ios,
          color: white,
          size: getFontSize(22),
        ),
        title: BoldText(
          text: title,
          size: 20,
          color: white,
        ),
        centerTitle: false,
        actions: [
          PopupMenuButton<String>(
            color: black,
            icon: const Icon(Icons.menu),
            iconColor: white,
            iconSize: getFontSize(22),
            padding: EdgeInsets.zero,
            onSelected: (String value) {
              _handleSelect(context, channelUrl);
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: '1',
                child: AppText(
                  text: 'Logout',
                  size: 15,
                  color: white,
                ),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        width: w,
        height: h,
        padding: getPadding(top: 5, left: 5, right: 5),
        child: Column(
          children: [
            Expanded(
              child: loading
                  ? Center(
                      child: CircularProgressIndicator(
                      color: white.withOpacity(0.7),
                      strokeWidth: 2,
                    ))
                  : messageList.isEmpty
                      ? Center(
                          child: AppText(
                              text: 'No chats',
                              size: 12,
                              color: white.withOpacity(0.6)))
                      : ScrollablePositionedList.builder(
                          initialScrollIndex: messageList.length - 1,
                          itemScrollController: itemScrollController,
                          itemCount: messageList.length,
                          itemBuilder: (context, index) {
                            BaseMessage message = messageList[index];
                            return message.sender!.userId == userId
                                ? Align(
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                      constraints:
                                          BoxConstraints(maxWidth: w * 0.73),
                                      margin: getMargin(
                                          right: 10, bottom: 10, top: 10),
                                      padding: getPadding(all: 8),
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            bottomRight: Radius.circular(15),
                                            bottomLeft: Radius.circular(15)),
                                        color: pink.withOpacity(0.4),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          AppText(
                                              text: message.message,
                                              color: white.withOpacity(0.9),
                                              lines: 1000,
                                              size: 13),
                                        ],
                                      ),
                                    ),
                                  )
                                : Padding(
                                    padding: getPadding(bottom: 10),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: getHorizontalSize(40),
                                          height: getVerticalSize(40),
                                          decoration: BoxDecoration(
                                              image: message.sender!.profileUrl
                                                      .isNotEmpty
                                                  ? DecorationImage(
                                                      image: NetworkImage(
                                                        message
                                                            .sender!.profileUrl,
                                                      ),
                                                      fit: BoxFit.cover,
                                                    )
                                                  : null,
                                              shape: BoxShape.circle,
                                              color: white.withOpacity(0.6)),
                                        ),
                                        Expanded(
                                            child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Container(
                                              constraints: BoxConstraints(
                                                  maxWidth: w * 0.73),
                                              margin: getMargin(left: 5),
                                              padding: getPadding(all: 8),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.only(
                                                        topRight:
                                                            Radius.circular(15),
                                                        bottomRight:
                                                            Radius.circular(15),
                                                        bottomLeft:
                                                            Radius.circular(
                                                                15)),
                                                color: white.withOpacity(0.2),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      ConstrainedBox(
                                                        constraints:
                                                            BoxConstraints(
                                                                maxWidth:
                                                                    w * 0.5),
                                                        child: AppText(
                                                          text: message
                                                              .sender!.userId,
                                                          size: 12,
                                                          color: white
                                                              .withOpacity(0.6),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                          width:
                                                              getHorizontalSize(
                                                                  5)),
                                                      message.sender!
                                                                  .connectionStatus ==
                                                              UserConnectionStatus
                                                                  .online
                                                          ? Ink(
                                                              height: 6,
                                                              width: 6,
                                                              decoration: const BoxDecoration(
                                                                  color: Colors
                                                                      .cyan,
                                                                  shape: BoxShape
                                                                      .circle),
                                                            )
                                                          : const SizedBox()
                                                    ],
                                                  ),
                                                  AppText(
                                                      text: message.message,
                                                      color: white
                                                          .withOpacity(0.7),
                                                      lines: 1000,
                                                      size: 13),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                                width: getHorizontalSize(2)),
                                            AppText(
                                              text: getTime(message.createdAt),
                                              size: 10,
                                              color: white.withOpacity(0.8),
                                            )
                                          ],
                                        )),
                                      ],
                                    ),
                                  );
                          },
                        ),
            ),
            TextFormField(
              controller: _messageController,
              onChanged: (value) {
                setState(() {
                  message = value;
                });
              },
              style: TextStyle(color: white.withOpacity(0.8), fontSize: 14),
              minLines: 1,
              maxLines: 4,
              cursorColor: white.withOpacity(0.6),
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Ink(
                    padding: getPadding(all: 5),
                    decoration: BoxDecoration(
                        color:
                            message.isNotEmpty ? pink : white.withOpacity(0.4),
                        shape: BoxShape.circle),
                    child: Icon(Icons.arrow_upward,
                        size: getFontSize(20),
                        color: message.isNotEmpty
                            ? black
                            : black.withOpacity(0.6)),
                  ),
                  onPressed: () {
                    // closeKeyboard(context);
                    if (_messageController.text.isNotEmpty) {
                      openChannel?.sendUserMessage(
                        UserMessageCreateParams(
                          message: _messageController.value.text,
                        ),
                        handler:
                            (UserMessage message, SendbirdException? e) async {
                          if (e != null) {
                            await _showDialogToResendUserMessage(message);
                          } else {
                            _addMessage(message);
                          }
                        },
                      );
                      _messageController.clear();

                      setState(() {
                        message = '';
                      });
                      // FocusScope.of(context).unfocus();
                      // Future.delayed(
                      //   const Duration(milliseconds: 500),
                      //   () => _scroll(messageList.length - 1),
                      // );
                    }
                  },
                ),
                fillColor: white.withOpacity(0.6),
                prefixIcon: IconButton(
                  icon: Ink(
                    padding: getPadding(all: 5),
                    decoration: BoxDecoration(
                        color: white.withOpacity(0.2), shape: BoxShape.circle),
                    child: Icon(Icons.add,
                        size: getFontSize(20), color: white.withOpacity(0.6)),
                  ),
                  onPressed: () {
                    // closeKeyboard(context);
                    if (_messageController.text.isNotEmpty) {
                      openChannel?.sendUserMessage(
                        UserMessageCreateParams(
                          message: _messageController.value.text,
                        ),
                        handler:
                            (UserMessage message, SendbirdException? e) async {
                          if (e != null) {
                            await _showDialogToResendUserMessage(message);
                          } else {
                            _addMessage(message);
                          }
                        },
                      );
                      _messageController.clear();

                      setState(() {
                        message = '';
                      });
                      // FocusScope.of(context).unfocus();
                      // Future.delayed(
                      //   const Duration(milliseconds: 500),
                      //   () => _scroll(messageList.length - 1),
                      // );
                    }
                  },
                ),
                hintText: "Type a message.",
                hintStyle: TextStyle(color: white.withOpacity(0.5)),
                contentPadding: const EdgeInsets.all(3),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide:
                      BorderSide(color: white.withOpacity(0.5), width: 1.0),
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide:
                        BorderSide(color: white.withOpacity(0.2), width: 1.0)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void didChangeMetrics() {
    _scroll(messageList.length - 1);
  }

  @override
  void dispose() {
    SendbirdChat.removeChannelHandler('OpenChannel');
    SendbirdChat.removeConnectionHandler('OpenChannel');
    _messageController.dispose();
    OpenChannel.getChannel(channelUrl).then((channel) => channel.exit());

    super.dispose();
  }

  // bool checkActive(int time){

  // }

  String getTime(timestamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat('HH:mm').format(dateTime);
  }

  Future<void> _showDialogToResendUserMessage(UserMessage message) async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            content: Text('Resend: ${message.message}'),
            actions: [
              TextButton(
                onPressed: () {
                  openChannel?.resendUserMessage(
                    message,
                    handler: (message, e) async {
                      if (e != null) {
                        await _showDialogToResendUserMessage(message);
                      } else {
                        _addMessage(message);
                      }
                    },
                  );

                  Navigator.pop(context);
                },
                child: const Text('Yes'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('No'),
              ),
            ],
          );
        });
  }

  void _addMessage(BaseMessage message) {
    OpenChannel.getChannel(channelUrl).then((openChannel) {
      setState(() {
        messageList.add(message);
        title = openChannel.name;
        participantCount = openChannel.participantCount;
      });

      Future.delayed(
        const Duration(milliseconds: 100),
        () => _scroll(messageList.length - 1),
      );
    });
  }

  void _updateParticipantCount() {
    OpenChannel.getChannel(channelUrl).then((openChannel) {
      setState(() {
        participantCount = openChannel.participantCount;
      });
    });
  }

  void _scroll(int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (messageList.length <= 1) return;

      while (!itemScrollController.isAttached) {
        await Future.delayed(const Duration(milliseconds: 1));
      }

      itemScrollController.scrollTo(
        index: index,
        duration: const Duration(milliseconds: 200),
        curve: Curves.fastOutSlowIn,
      );
    });
  }
}

void _handleSelect(BuildContext context, channelUrl) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.clear();
  OpenChannel.getChannel(channelUrl).then((channel) => channel.exit());

  Phoenix.rebirth(context);
}

class MyOpenChannelHandler extends OpenChannelHandler {
  final _ChatPageState _state;

  MyOpenChannelHandler(this._state);

  @override
  void onMessageReceived(BaseChannel channel, BaseMessage message) {
    _state._addMessage(message);
  }

  @override
  void onMessageUpdated(BaseChannel channel, BaseMessage message) {
    // _state._updateMessage(message);
  }

  @override
  void onMessageDeleted(BaseChannel channel, int messageId) {
    // _state._deleteMessage(messageId);
  }

  @override
  void onUserEntered(OpenChannel channel, User user) {
    _state._updateParticipantCount();
  }

  @override
  void onUserExited(OpenChannel channel, User user) {
    _state._updateParticipantCount();
  }
}

class MyConnectionHandler extends ConnectionHandler {
  final _ChatPageState _state;

  MyConnectionHandler(this._state);

  @override
  void onConnected(String userId) {}

  @override
  void onDisconnected(String userId) {}

  @override
  void onReconnectStarted() {}

  @override
  void onReconnectSucceeded() {
    _state._initialize();
  }

  @override
  void onReconnectFailed() {}
}
