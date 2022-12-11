import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/layout/social_app/cubit/states.dart';
import 'package:untitled/models/social_app/post_model.dart';
import 'package:untitled/models/social_app/social_user_model.dart';
import 'package:untitled/modules/social_app/feeds/feeds_screen.dart';
import 'package:untitled/modules/social_app/new_post/new_post_screen.dart';
import 'package:untitled/modules/social_app/settings/settings_screen.dart';
import 'package:untitled/modules/social_app/users/users_screen.dart';
import 'package:untitled/shared/styles/icon_broken.dart';
import '../../../models/social_app/message_model.dart';
import '../../../modules/social_app/chats/chats_screen.dart';
import '../../../shared/components/constants.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialState());

  static SocialCubit get(context) => BlocProvider.of(context);

  SocialUserModel? userModel;

  void getUserData() {
    emit(SocialGetUserLoadingState());

    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      //print(value.data());
      userModel = SocialUserModel.fromJson(value.data()!);
      emit(SocialGetUserSuccessState());
    }).catchError((error) {
      print(error);
      emit(SocialGetUserErrorState(error.toString()));
    });
  }

  int currentIndex = 0;

  List<Widget> screens =
  [
    FeedsScreen(),
    const ChatsScreen(),
    NewPostScreen(),
    const UsersScreen(),
    const SettingsScreen(),
  ];

  List<IconData> titles =
  [
    IconBroken.Home,
    IconBroken.Chat,
    IconBroken.Paper_Upload,
    IconBroken.User,
    IconBroken.Setting,

  ];

  void changeBottomNav(int index)
  {
    if(index == 1)
    {
      getUsers();
    }

    if (index == 2) {
      emit(SocialNewPostState());
    } else {
      currentIndex = index;
      emit(SocialChangeBottomNavState());
    }
  }

  File? profileImage;
  var picker = ImagePicker();

  Future<void> getProfileImage() async
  {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(SocialProfileImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(SocialProfileImagePickedErrorState());
    }
  }

  File? coverImage;

  Future<void> getCoverImage() async
  {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(SocialCoverImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(SocialCoverImagePickedErrorState());
    }
  }


  void uploadProfileImage({
    required String name,
    required String bio,
    required String phone,
  }) {
    emit(SocialUserUpdateLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri
        .file((profileImage?.path)!)
        .pathSegments
        .last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        //emit(SocialUploadProfileImageSuccessState());
        updateUser(
          name: name,
          bio: bio,
          phone: phone,
          image: value,
        );
      }).catchError((error) {
        emit(SocialUploadProfileImageErrorState());
      });
    })
        .catchError((error) {
      emit(SocialUploadProfileImageErrorState());
    });
  }


  void uploadCoverImage({
    required String name,
    required String bio,
    required String phone,
  }) {
    emit(SocialUserUpdateLoadingState());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri
        .file((coverImage?.path)!)
        .pathSegments
        .last}')
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        //emit(SocialUploadCoverImageSuccessState());
        updateUser(
          name: name,
          bio: bio,
          phone: phone,
          cover: value,
        );
      }).catchError((error) {
        emit(SocialUploadCoverImageErrorState());
      });
    })
        .catchError((error) {
      emit(SocialUploadCoverImageErrorState());
    });
  }

//   void updateUserImages({
//   required String name,
//   required String bio,
//   required String phone,
// })
//   {
//     emit(SocialUserUpdateLoadingState());
//
//     if(coverImage != null)
//       {
//         uploadCoverImage();
//       } else if(profileImage != null)
//         {
//           uploadProfileImage();
//         } else if (coverImage != null && profileImage != null)
//           {
//
//           } else
//           {
//             updateUser(
//               name: name,
//               bio: bio,
//               phone: phone,
//             );
//           }
//   }

  void updateUser({
    required String name,
    required String bio,
    required String phone,
    String? image,
    String? cover,
  }) {
    SocialUserModel model = SocialUserModel(
      name: name,
      phone: phone,
      bio: bio,
      uId: (userModel?.uId)!,
      email: (userModel?.email)!,
      image:( image ?? userModel?.image)!,
      cover: (cover ?? userModel?.cover)!,
      isEmailVerified: false,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel?.uId)
        .update(model.toMap())
        .then((value) {
      getUserData();
    })
        .catchError((error) {
      emit(SocialUserUpdateErrorState());
    });
  }

  File? postImage;

  Future<void> getPostImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(SocialPostImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(SocialPostImagePickedErrorState());
    }
  }

  void removePostImage() {
    postImage = null;
    emit(SocialRemovePostImageState());
  }


  void uploadPostImage({
    required String dateTime,
    required String text,
  }) {
    emit(SocialCreatePostLoadingState());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri
        .file((postImage?.path)!)
        .pathSegments
        .last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        createPost(
          dateTime: dateTime,
          text: text,
          postImage: value,
        );
      }).catchError((error) {
        emit(SocialCreatePostErrorState());
      });
    })
        .catchError((error) {
      emit(SocialCreatePostErrorState());
    });
  }

  void createPost({
    required String dateTime,
    required String text,
    String? postImage,
  }) {
    emit(SocialCreatePostLoadingState());

    PostModel model = PostModel(
      name: (userModel?.name)!,
      uId: (userModel?.uId)!,
      image: (userModel?.image)!,
      dateTime: dateTime,
      text: text,
      postImage: postImage ?? '',
    );

    FirebaseFirestore.instance
        .collection('posts')
        .add(model.toMap())
        .then((value) {
      emit(SocialCreatePostSuccessState());
    })
        .catchError((error) {
      emit(SocialCreatePostErrorState());
    });
  }

  List<PostModel> posts = [];

  List<String> postsId = [];

  List<int> likes = [];


  void getPosts() {
    FirebaseFirestore.instance.collection('posts')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        element.reference
            .collection('likes')
            .get()
            .then((value) {
          likes.add(value.docs.length);
          postsId.add(element.id);
          posts.add(PostModel.fromJson(element.data()));
        })
            .catchError((error) {});
      });
      emit(SocialGetPostsSuccessState());
    }).catchError((error) {
      emit(SocialGetPostsErrorState(error.toString()));
    });
  }

  List<int> comments = [];

  void getComments() {
    FirebaseFirestore.instance.collection('posts')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        element.reference
            .collection('comments')
            .get()
            .then((value) {
          comments.add(value.docs.length);
        })
            .catchError((error) {});
      });
      emit(SocialGetCommentsSuccessState());
    }).catchError((error) {
      emit(SocialGetCommentsErrorState(error.toString()));
    });
  }

  void likePost(String postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userModel?.uId)
        .set({'like': true})
        .then((value) {
      emit(SocialLikePostSuccessState());
    })
        .catchError((error) {
      emit(SocialLikePostErrorState(error.toString()));
    });
  }

  void commentPost(String postId, String comment) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(userModel?.uId)
        .set({'comment': comment})
        .then((value) {
      emit(SocialCommentPostSuccessState());
    })
        .catchError((error) {
      emit(SocialCommentPostErrorState(error.toString()));
    });
  }

 List<SocialUserModel> users = [];

  void getUsers()
  {
    emit(SocialGetAllUsersLoadingState());
    if(users.isEmpty) {
      FirebaseFirestore.instance.collection('users')
        .get()
        .then((value)
    {
      value.docs.forEach((element)
      {
        if(element.data()['uId'] != userModel?.uId) {
          users.add(SocialUserModel.fromJson(element.data()));
        }
      });

      emit(SocialGetAllUsersSuccessState());
    }).catchError((error)
    {
      emit(SocialGetAllUsersErrorState(error.toString()));
    });
    }
  }

  void sendMessage({
  required String receiverId,
    required String dateTime,
    required String text,
})
  {
    MessageModel model = MessageModel(
      text: text,
      senderId: (userModel?.uId)!,
      receiverId: receiverId,
      dateTime: dateTime,
    );

    // set my chats

    FirebaseFirestore.instance
    .collection('users')
    .doc(userModel?.uId)
    .collection('chats')
    .doc(receiverId)
    .collection('messages')
    .add(model.toMap())
    .then((value) {
      emit(SocialSendMessageSuccessState());
    })
    .catchError((error){
      emit(SocialSendMessageErrorState());
    });

    //set receiver chats

    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(userModel?.uId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    })
        .catchError((error){
      emit(SocialSendMessageErrorState());
    });

  }

  List<MessageModel> messages = [];

  void getMessages({
    required String receiverId,
  })
  {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel?.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event)
    {
      messages = [];

      event.docs.forEach((element)
      {
        messages.add(MessageModel.fromJson(element.data()));
      });

      emit(SocialGetMessagesSuccessState());
    });
  }
}
