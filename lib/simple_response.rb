module SimpleResponse
  def response(opts = {})
    opts[:errors] =
      if opts[:errors].present?
        opts[:errors]
      elsif errors.present?
        errors
      else
        {}
      end

    opts[:message] =
      if opts[:message].present?
        opts[:message]
      elsif opts[:errors].any?
        'Parameters are invalid!'
      else
        ''
      end

    if opts[:message].present? && opts[:errors].blank?
      # to set to failed!
      errors.add(:parameter, 'Invalid request!')
    end

    {
      success: opts[:errors].blank? && opts[:message].blank?,
      data: opts[:data] || {},
      message: opts[:message],
      errors: opts[:errors]
    }
  end
end
