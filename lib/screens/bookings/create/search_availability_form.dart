import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SearchAvailabilityForm extends StatefulWidget {

	final Function callback;

	const SearchAvailabilityForm({
		required this.callback,
		Key? key
	}) : super(key: key);

	@override
	_SearchAvailabilityFormState createState() => _SearchAvailabilityFormState();

}

class _SearchAvailabilityFormState extends State<SearchAvailabilityForm> {

	final _formKey = GlobalKey<FormState>();

	String _checkInDate = DateFormat('yyyy-MM-dd').format( DateTime.now() );
	String _checkOutDate = DateFormat('yyyy-MM-dd').format(
		DateTime.now().add(const Duration(days: 1)) );

	String _adults = '1';
	String _children = '0';

	final checkInController = TextEditingController();
	final checkOutController = TextEditingController();

	void _showDateRangePicker() async {

		final DateTimeRange? dateRange = await showDateRangePicker(
			context: context,
			firstDate: DateTime( DateTime.now().year - 10 ),
			lastDate: DateTime( DateTime.now().year + 10, 12, 31 ),
			currentDate: DateTime.parse( _checkInDate ),
		);

		if (dateRange != null) {

			setState(() {
				_checkInDate = DateFormat('yyyy-MM-dd').format( dateRange.start );
				_checkOutDate = DateFormat('yyyy-MM-dd').format( dateRange.end );
			});

			checkInController.text = _checkInDate;
			checkOutController.text = _checkOutDate;
		}
	}

	@override
	void initState() {

		super.initState();

		checkInController.text = _checkInDate;
		checkOutController.text = _checkOutDate;
	}

	@override
	void dispose() {

		checkInController.dispose();
		checkOutController.dispose();

		super.dispose();
	}

	@override
	Widget build(BuildContext context) {

		return Form(
			key: _formKey,
			child: Column(
				children: [
					Row(
						children: [
							Expanded(
								child: TextFormField(
									controller: checkInController,
									keyboardType: TextInputType.numberWithOptions(signed: true),
									decoration: const InputDecoration(
										isDense: true,
										hintText: '1970-12-31',
										labelText: 'Check-in',
										floatingLabelBehavior: FloatingLabelBehavior.always,
										border: OutlineInputBorder(),
									),
									validator: (value) {
										if (value == null || value.isEmpty) {
											return 'Please enter date';
										}
										return null;
									},
									onChanged: (newValue) {
										setState(() {
											_checkInDate = newValue;
										});
									},
								),
							),
							SizedBox(width: 10),
							Expanded(
								child: TextFormField(
									controller: checkOutController,
									keyboardType: TextInputType.numberWithOptions(signed: true),
									decoration: const InputDecoration(
										isDense: true,
										hintText: '1970-12-31',
										labelText: 'Check-out',
										floatingLabelBehavior: FloatingLabelBehavior.always,
										border: OutlineInputBorder(),
									),
									validator: (value) {
										if (value == null || value.isEmpty) {
											return 'Please enter date';
										}
										return null;
									},
									onChanged: (newValue) {
										setState(() {
											_checkOutDate = newValue;
										});
									},
								),
							),
							IconButton(
								icon: const Icon(Icons.date_range),
								onPressed: _showDateRangePicker,
							),
						],
					),
					SizedBox(height: 10),
					Row(
						children: [
							Expanded(
								child: DropdownButtonFormField<String>(
									decoration: const InputDecoration(
										isDense: true,
										labelText: 'Adults',
										border: OutlineInputBorder(),
									),
									value: _adults,

									items: List<String>.generate(
										30, (i) => (i + 1).toString()).map((String value) {

										return DropdownMenuItem<String>(
											value: value,
											child: Text(value),
										);
									}).toList(),

									onChanged: (String? newValue) {
										setState(() {
											_adults = newValue!;
										});
									},
								)
							),
							SizedBox(width: 10),
							Expanded(
								child: DropdownButtonFormField<String>(
									decoration: const InputDecoration(
										isDense: true,
										labelText: 'Children',
										border: OutlineInputBorder(),
									),
									value: _children,
									items: List<String>.generate(
										31, (i) => (i).toString()).map((String value) {

										return DropdownMenuItem<String>(
											value: value,
											child: Text(value),
										);
									}).toList(),

									onChanged: (String? newValue) {
										setState(() {
											_children = newValue!;
										});
									},
								)
							),
						],
					),
					SizedBox(height: 10),
					Row(
						children: [
							Expanded(
								child: ElevatedButton(
									onPressed: () {

										//remove focus from fields
										FocusScopeNode currentFocus = FocusScope.of(context);
										if (!currentFocus.hasPrimaryFocus) {
											currentFocus.unfocus();
										}

										if (_formKey.currentState!.validate()) {

											var params = {
												'check_in_date': _checkInDate,
												'check_out_date': _checkOutDate,
												'adults': _adults,
												'children': _children
											};
											widget.callback( params );
										}
									},
									child: const Text('Search',),
								),
							),
						]
					),
				]
			),
		);

	}

}
