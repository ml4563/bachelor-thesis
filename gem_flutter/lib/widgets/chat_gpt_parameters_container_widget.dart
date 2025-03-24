import 'package:flutter/material.dart';
import 'package:gem_flutter/widgets/dropdown_widget.dart';
import 'package:gem_flutter/widgets/input_quantity_double_widget.dart';
import 'package:gem_flutter/widgets/input_quantity_int_widget.dart';
import 'package:gem_flutter/widgets/text_field_widget.dart';
import '../utils/global_variables.dart';

/// A widget that displays a container for configuring ChatGPT parameters.
class ChatGptParametersContainerWidget extends StatefulWidget {
  /// The current ChatGPT parameters.
  final Map<String, dynamic> chatGptParameters;

  /// Callback function to handle parameter changes.
  final Function(String, dynamic) onChanged;

  const ChatGptParametersContainerWidget({
    required this.chatGptParameters,
    required this.onChanged,
    super.key,
  });

  @override
  ChatGptParametersContainerWidgetState createState() =>
      ChatGptParametersContainerWidgetState();
}

class ChatGptParametersContainerWidgetState
    extends State<ChatGptParametersContainerWidget> {
  /// Controller for the content text field.
  late TextEditingController contentController;

  @override
  void initState() {
    super.initState();
    contentController =
        TextEditingController(text: widget.chatGptParameters['content']);
  }

  /// Builds an [InputQuantityIntWidget] for integer parameters (max tokens and threshold word)
  Widget _buildInputQuantityInt(
    BuildContext context,
    String label,
    String parameterKey,
    int minValue,
    int maxValue,
    int initValue,
    int stepsValue,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSecondary,
              ),
        ),
        GlobalVariables.smallVerticalSizedBox,
        InputQuantityIntWidget(
          minVal: minValue,
          maxVal: maxValue,
          initVal: initValue,
          steps: stepsValue,
          onChanged: (value) {
            widget.onChanged(parameterKey, value);
          },
        ),
      ],
    );
  }

  /// Builds an [InputQuantityDoubleWidget] for double parameters (frequency penalty, presence penalty, temperature, top p)
  Widget _buildInputQuantityDouble(
    BuildContext context,
    String label,
    String parameterKey,
    double minValue,
    double maxValue,
    double initValue,
    double stepsValue,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSecondary,
              ),
        ),
        GlobalVariables.smallVerticalSizedBox,
        InputQuantityDoubleWidget(
          minVal: minValue,
          maxVal: maxValue,
          initVal: initValue,
          steps: stepsValue,
          onChanged: (value) {
            widget.onChanged(parameterKey, value);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Row for model and content
        Row(
          children: [
            Expanded(
              // Model
              child: DropdownWidget(
                label: GlobalVariables.modelLabel,
                value: widget.chatGptParameters['model'],
                items: GlobalVariables.modelList,
                onChanged: (newValue) {
                  setState(() {
                    widget.onChanged('model', newValue);
                  });
                },
              ),
            ),
            GlobalVariables.smallhorizontalSizedBox,
            Expanded(
              child: Column(
                children: [
                  Text(
                    GlobalVariables.systemMessageContentLabel,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.onSecondary,
                    ),
                  ),
                  GlobalVariables.smallVerticalSizedBox,
                  // Content
                  TextFieldWidget(
                    controller: contentController,
                    minLines: 1,
                    maxLines: 3,
                    onChanged: (value) {
                      widget.onChanged('content', value);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        GlobalVariables.mediumVerticalSizedBox,
        // Row for frequency_penalty and presence_penalty
        Row(
          children: [
            Expanded(
              // Frequency_penalty
              child: _buildInputQuantityDouble(
                context,
                GlobalVariables.frequencyPenaltyLabel,
                'frequencyPenalty',
                GlobalVariables.presenceFrequencyPenaltyMinValue,
                GlobalVariables.presenceFrequencyPenaltyMaxValue,
                widget.chatGptParameters['frequencyPenalty'],
                GlobalVariables.stepsValueDoubleParams,
              ),
            ),
            GlobalVariables.smallhorizontalSizedBox,
            Expanded(
              // Presence_penalty
              child: _buildInputQuantityDouble(
                context,
                GlobalVariables.presencePenaltyLabel,
                'presencePenalty',
                GlobalVariables.presenceFrequencyPenaltyMinValue,
                GlobalVariables.presenceFrequencyPenaltyMaxValue,
                widget.chatGptParameters['presencePenalty'],
                GlobalVariables.stepsValueDoubleParams,
              ),
            ),
          ],
        ),
        GlobalVariables.smallVerticalSizedBox,
        // Row for temperature and top_p
        Row(
          children: [
            Expanded(
              // Temperature
              child: _buildInputQuantityDouble(
                context,
                GlobalVariables.temperatureLabel,
                'temperature',
                GlobalVariables.temperatureMinValue,
                GlobalVariables.temperatureMaxValue,
                widget.chatGptParameters['temperature'],
                GlobalVariables.stepsValueDoubleParams,
              ),
            ),
            GlobalVariables.smallhorizontalSizedBox,
            Expanded(
              // Top_p
              child: _buildInputQuantityDouble(
                context,
                GlobalVariables.topPLabel,
                'topP',
                GlobalVariables.topPMinValue,
                GlobalVariables.topPMaxValue,
                widget.chatGptParameters['topP'],
                GlobalVariables.stepsValueDoubleParams,
              ),
            ),
          ],
        ),
        GlobalVariables.smallVerticalSizedBox,
        // Row for max_token and threshold_word
        Row(
          children: [
            Expanded(
              // Max_token
              child: _buildInputQuantityInt(
                context,
                GlobalVariables.maxTokensLabel,
                'maxTokens',
                GlobalVariables.maxTokensMinValue,
                GlobalVariables.maxTokensMaxValue,
                widget.chatGptParameters['maxTokens'],
                GlobalVariables.stepsValueIntParams,
              ),
            ),
            GlobalVariables.smallhorizontalSizedBox,
            Expanded(
              // Threshold_word
              child: _buildInputQuantityInt(
                context,
                GlobalVariables.thresholdWordLabel,
                'threshold',
                GlobalVariables.thresholdWordMinValue,
                GlobalVariables.thresholdWordMaxValue,
                widget.chatGptParameters['threshold'],
                GlobalVariables.stepsValueIntParams,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
