# frozen_string_literal: true

class Auditor
  def after_create(subject)
    push_audit_for('create', subject)
  end

  def after_update(subject)
    push_audit_for('update', subject)
  end

  def after_destroy(subject)
    push_audit_for('destroy', subject)
  end

  def self.audit
    @audit ||= []
  end

  private

  def push_audit_for(action, subject)
    self.class.audit.push(audit_for(action, subject))
  end

  def audit_for(action, subject)
    {
      action: action,
      subject_id: subject.id,
      subject_class: subject.class.to_s,
      changes: subject.previous_changes,
      created_at: Time.zone.now
    }
  end
end
