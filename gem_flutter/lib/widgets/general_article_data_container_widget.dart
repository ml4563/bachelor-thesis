import 'package:flutter/material.dart';
import 'package:gem_flutter/utils/global_variables.dart';
import 'package:gem_flutter/widgets/dropdown_widget.dart';
import 'package:gem_flutter/widgets/input_quantity_int_widget.dart';
import 'package:jiffy/jiffy.dart';

/// A widget for displaying and managing general article data input fields.
class GeneralArticleDataContainerWidget extends StatefulWidget {
  /// Map containing general article data.
  final Map<String, dynamic> generalArticleData;

  /// Callback function to handle changes in the article data.
  final Function(String, dynamic) onChanged;

  const GeneralArticleDataContainerWidget({
    required this.generalArticleData,
    required this.onChanged,
    super.key,
  });

  @override
  GeneralArticleDataContainerWidgetState createState() =>
      GeneralArticleDataContainerWidgetState();
}

class GeneralArticleDataContainerWidgetState
    extends State<GeneralArticleDataContainerWidget> {
  /// The currently selected date.
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
  }

  /// Picks a date using a date picker dialog.
  ///
  /// Updates the selected week number when a date is picked.
  void _pickDate(BuildContext context) async {
    DateTime? newSelectedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1800),
      lastDate: DateTime.now(),
    );

    if (newSelectedDate != null) {
      int weekNumber = _getWeekNumber(newSelectedDate);
      setState(() {
        selectedDate = newSelectedDate;
      });
      widget.onChanged('semaine', weekNumber);
    }
  }

  /// Gets the week number for a given date.
  int _getWeekNumber(DateTime date) {
    int weekNumber = Jiffy.parseFromDateTime(date).weekOfYear;
    return weekNumber;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    GlobalVariables.noLabel,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.onSecondary,
                    ),
                  ),
                  GlobalVariables.smallVerticalSizedBox,
                  // Number of the article
                  InputQuantityIntWidget(
                    minVal: 0,
                    maxVal: 100000,
                    initVal: widget.generalArticleData['no'],
                    steps: 1,
                    onChanged: (value) {
                      widget.onChanged('no', value);
                    },
                  ),
                ],
              ),
            ),
            GlobalVariables.smallhorizontalSizedBox,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Media
                  DropdownWidget(
                    label: GlobalVariables.mediaLabel,
                    value: GlobalVariables.mediaMap.entries
                        .firstWhere((entry) =>
                            entry.value == widget.generalArticleData['media'])
                        .key,
                    items: GlobalVariables.mediaMap.keys.toList(),
                    onChanged: (value) {
                      if (value != null) {
                        widget.onChanged(
                            'media', GlobalVariables.mediaMap[value]);
                      }
                    },
                  ),
                  GlobalVariables.mediumVerticalSizedBox,
                ],
              ),
            ),
          ],
        ),
        GlobalVariables.mediumVerticalSizedBox,
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    GlobalVariables.dateLabel,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.onSecondary,
                    ),
                  ),
                  GlobalVariables.smallVerticalSizedBox,
                  // Date
                  InkWell(
                    onTap: () => _pickDate(context),
                    child: SizedBox(
                      width: 250,
                      child: InputDecorator(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                GlobalVariables.borderRadiusSize),
                          ),
                          filled: true,
                          fillColor: theme.colorScheme.tertiary,
                          contentPadding: GlobalVariables.mediumPadding,
                        ),
                        child: Text(
                          "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                          style: theme.textTheme.displaySmall
                              ?.copyWith(color: theme.colorScheme.onTertiary),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GlobalVariables.smallhorizontalSizedBox,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Reprinted article
                  DropdownWidget(
                    label: GlobalVariables.reprintedArticleLabel,
                    value: GlobalVariables.reprintedArticleMap.entries
                        .firstWhere((entry) =>
                            entry.value ==
                            widget.generalArticleData['articleRepris'])
                        .key,
                    items: GlobalVariables.reprintedArticleMap.keys.toList(),
                    onChanged: (value) {
                      if (value != null) {
                        widget.onChanged('articleRepris',
                            GlobalVariables.reprintedArticleMap[value]);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
