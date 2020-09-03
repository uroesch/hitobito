# encoding: utf-8

#  Copyright (c) 2012-2020, CVP Schweiz. This file is part of
#  hitobito_cvp and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cvp.

class Address::Check


  ADDRESS_REGEX = /(.+?)\s*(\d+)*$/.freeze

  delegate :street, :town, :zip_code, to: :person
  delegate :town, :country, to: :contactable

  attr_reader :contactable

  def initialize(person)
    @contactable = person
  end

  def run
    contactable.tag_list.add("address:#{state}")
    contactable.save
  end

  def state
    if blank?
      :missing
    elsif partial?
      :partial
    elsif valid?
      :valid
    else
      :invalid
    end
  end

  def partial?
    field_values.any?(&:blank?)
  end

  def blank?
    field_values.all?(&:blank?)
  end

  def valid?
    address = Address.find_by(fields.except(:number))
    address.numbers.include?(Integer(number)) if address
  end

  def number
    contactable.address.to_s[ADDRESS_REGEX, 2].presence
  end

  def street
    contactable.address.to_s[ADDRESS_REGEX, 1].presence
  end

  def zip_code
    contactable.zip_code.presence
  end

  def field_values
    fields.values
  end

  def fields
    [:street, :number, :town, :zip_code].index_with { |field| send(field) }
  end

end

