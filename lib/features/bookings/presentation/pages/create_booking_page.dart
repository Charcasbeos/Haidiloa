import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:haidiloa/features/bookings/presentation/bloc/booking_bloc.dart';
import 'package:haidiloa/features/bookings/presentation/bloc/booking_event.dart';
import 'package:haidiloa/features/bookings/presentation/bloc/booking_state.dart';

class CreateBookingPage extends StatefulWidget {
  const CreateBookingPage({Key? key}) : super(key: key);

  @override
  State<CreateBookingPage> createState() => _CreateBookingPageState();
}

class _CreateBookingPageState extends State<CreateBookingPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  final _noteController = TextEditingController();
  DateTime selectedDateTime = DateTime.now();
  int persons = 1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocConsumer<BookingBloc, BookingState>(
      listener: (context, state) {
        if (state is BookingSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
          Navigator.pop(context);
        } else if (state is BookingFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xfffcf4db),
            title: const Text(
              "Booking",
              style: TextStyle(
                color: Color(0xffdc0405),
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,

                    decoration: InputDecoration(
                      labelText: 'Số điện thoại',
                      floatingLabelStyle: TextStyle(color: Colors.blue[300]),
                      prefixIcon: const Icon(Icons.phone),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.blue,

                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Nhập SĐT';
                      }
                      final phoneReg = RegExp(
                        r'^(0[1-9][0-9]{8})$',
                      ); // 10 số VN
                      if (!phoneReg.hasMatch(value.trim())) {
                        return 'SĐT không hợp lệ';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      floatingLabelStyle: TextStyle(color: Colors.blue[300]),
                      labelText: 'Tên khách hàng',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.blue,

                          width: 1,
                        ),
                      ),
                    ),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Nhập tên'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: _pickDateTime,
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Ngày giờ',
                        floatingLabelStyle: TextStyle(color: Colors.blue[300]),
                        prefixIcon: const Icon(Icons.calendar_today),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.blue,

                            width: 1,
                          ),
                        ),
                      ),
                      child: Text(
                        DateFormat('HH:mm dd/MM/yyyy').format(selectedDateTime),
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<int>(
                    value: persons,
                    decoration: InputDecoration(
                      floatingLabelStyle: TextStyle(color: Colors.blue[300]),
                      labelText: 'Số người',
                      prefixIcon: const Icon(Icons.people),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.blue,

                          width: 1,
                        ),
                      ),
                    ),
                    items: List.generate(
                      60,
                      (index) => DropdownMenuItem<int>(
                        value: index + 1,
                        child: Text('${index + 1} người'),
                      ),
                    ),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => persons = value);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _noteController,
                    decoration: InputDecoration(
                      floatingLabelStyle: TextStyle(color: Colors.blue[300]),
                      labelText: 'Ghi chú',
                      hintText: 'Ví dụ: ngày kỷ niệm, dị ứng ...',
                      prefixIcon: const Icon(Icons.notes),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.blue,

                          width: 1,
                        ),
                      ),
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: state is BookingLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add, color: Colors.white),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: const Color(0xffdc0405),
                    ),
                    label: const Text(
                      'Tạo booking',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<BookingBloc>().add(
                          CreateBookingEvent(
                            phone: _phoneController.text.trim(),
                            name: _nameController.text.trim(),
                            time: selectedDateTime,
                            persons: persons,
                            note: _noteController.text.trim(),
                          ),
                        );
                      }
                    },
                  ),
                ),
        );
      },
    );
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (date == null) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDateTime),
    );
    if (time == null) return;

    setState(() {
      selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }
}
