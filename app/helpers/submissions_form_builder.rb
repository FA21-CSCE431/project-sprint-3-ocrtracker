# frozen_string_literal: true

class SubmissionsFormBuilder < ActionView::Helpers::FormBuilder
  def text_or_time_field(attribute, options = {})
    # if options[:unit_name] == 'time_h_to_l' || options[:unit_name] == 'time_l_to_h'
    if options[:unit_name].starts_with?('time')
      if options[:value] != nil
        label('minutes') + text_field('minutes',:value => ((options[:value].to_i)/60))+ label('seconds') + text_field('seconds', :value => ((options[:value].to_f)%60))
      else
        label('minutes') + text_field('minutes',objectify_options(options)) + label('seconds') + text_field('seconds', objectify_options(options))
      end
    else
      label('unit_value', 'Number') + text_field(attribute, objectify_options(options))
    end
  end
end
