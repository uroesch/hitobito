# encoding: utf-8

#  Copyright (c) 2012-2020, CVP Schweiz. This file is part of
#  hitobito_cvp and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cvp.
#
# == Schema Information
#
# Table name: addresses
#
#  id       :bigint           not null, primary key
#  street   :string(255)      not null
#  town     :string(255)      not null
#  zip_code :integer          not null
#  state    :string(255)      not null
#  numbers  :text(65535)
#

require 'spec_helper'

describe Address do
  it 'serializes number as array' do
    address = Address.create!(street: 'Belpstrasse', zip_code: 3005, town: 'Bern', state: 'BE', numbers: [1,2,3])
    expect(Address.find(address.id).numbers).to eq [1,2,3]
  end
end
