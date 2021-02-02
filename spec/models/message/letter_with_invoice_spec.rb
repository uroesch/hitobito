# frozen_string_literal: true

# == Schema Information
#
# Table name: messages
#
#  id                 :bigint           not null, primary key
#  failed_count       :integer          default(0)
#  invoice_attributes :text(65535)
#  recipient_count    :integer          default(0)
#  sent_at            :datetime
#  state              :string(255)      default("draft")
#  subject            :string(1024)     not null
#  success_count      :integer          default(0)
#  type               :string(255)      not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  invoice_list_id    :bigint
#  mailing_list_id    :bigint
#  sender_id          :bigint
#
# Indexes
#
#  index_messages_on_invoice_list_id  (invoice_list_id)
#  index_messages_on_mailing_list_id  (mailing_list_id)
#  index_messages_on_sender_id        (sender_id)
#


#  Copyright (c) 2012-2021, CVP Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

require 'spec_helper'

describe Message::LetterWithInvoice do
  let(:invoice_attrs) {
    {
      'invoice_items_attributes' => {
        '1' =>{'name'=>'Mitgliedsbeitrag 2021', '_destroy' => 'false' }
      }
    }
  }

  it 'new record accepts invoice_attributes' do
    subject.mailing_list = mailing_lists(:leaders)
    subject.invoice_attributes = invoice_attrs
    expect(subject.invoice.invoice_items.first.name).to eq 'Mitgliedsbeitrag 2021'
  end

  it 'persisted record accepts updates to invoice_attributes' do
    message = messages(:with_invoice)
    message.update(invoice_attributes: invoice_attrs)
    expect(message.reload.invoice.invoice_items.first.name).to eq 'Mitgliedsbeitrag 2021'
  end

  it 'builds valid invoice_list' do
    message = messages(:with_invoice)
    expect(message.invoice_list).to be_valid
    message.save
    expect(message.invoice_list).to be_persisted
  end

  context 'invoice' do
    let(:group)     { groups(:top_layer) }
    let(:recipient) { people(:bottom_member) }

    subject { messages(:with_invoice) }

    it '#invoice_for returns valid invoice' do
      invoice = subject.invoice_for(recipient)
      expect(invoice).to be_valid
      expect(invoice.recipient_address).to be_present
    end
  end
end
