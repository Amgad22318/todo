import 'package:flutter/material.dart';
import 'package:todo/layout/todo_app/cubit/cubit.dart';


Widget defaultButton({
  bool isUpperCase = true,
  double width = double.infinity,
  double radius = 0,
  Color background = Colors.blue,
  required VoidCallback onPressed, // voidcallback = void Function()
  required String text,
}) =>
    Container(
      height: 40,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: background,
      ),
      child: MaterialButton(
        onPressed: onPressed,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );

Widget defaultFormField(
        {required TextEditingController controller,
        required String labelText,
        required TextInputType keyboardType,
        required IconData prefixIcon,
        required String? Function(String?)? validator,
        Function? onFieldSubmitted,
        void Function(String)? onChanged,
        VoidCallback? suffixIconOnPressed,
        IconData? suffixIcon,
        bool obscureText = false,
        VoidCallback? onTap}) =>
    TextFormField(
      onTap: onTap,
      obscureText: obscureText,
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
        prefixIcon: Icon(prefixIcon),
        suffixIcon: IconButton(
          onPressed: suffixIconOnPressed,
          icon: Icon(suffixIcon),
        ),
      ),
      keyboardType: keyboardType,
      onFieldSubmitted: (s) {
        onFieldSubmitted!(s);
      },
      // or like this
      onChanged: onChanged,
      validator: validator,
    );

Widget buildTaskItem(Map model,context) => Dismissible(
  key: Key(model['id'].toString()),
  onDismissed: (direction) {
    AppCubit.get(context).deleteData(id: model['id']);
  },
  child:   Padding(

        padding: const EdgeInsets.all(8.0),

        child: Row(

          children: [

            CircleAvatar(

              radius: 40,

              child: Text('${model['time']}'),

            ),

            SizedBox(

              width: 20,

            ),

            Expanded(

              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,

                mainAxisSize: MainAxisSize.min,

                children: [

                  Text(

                    '${model['title']}',

                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),

                    maxLines: 2,

                    overflow: TextOverflow.ellipsis,

                  ),

                  SizedBox(

                    height: 10,

                  ),

                  Text(

                    '${model['date']}',

                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,color: Colors.grey),



                  ),

                ],

              ),

            ),

            SizedBox(

              width: 20,

            ),

            IconButton(onPressed: () {

              AppCubit.get(context).updateData(status: 'done', id: model['id']);

            }, icon: Icon(Icons.check_circle),color: Colors.green,),

            IconButton(onPressed: () {

              AppCubit.get(context).updateData(status: 'archive', id: model['id']);

            }, icon: Icon(Icons.archive_outlined),color: Colors.black45,),

          ],

        ),

      ),
);
