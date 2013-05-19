class Rosetta::Concern::PhraseKey
  attr_reader :localizable
  attr_reader :namespace
  attr_reader :identifier
  attr_reader :attribute_name

  def initialize(localizable, attr, opts = {})
    @localizable    = localizable
    @attribute_name = attr
    @separator      = opts[:separator] || '.'

    define_namespace
    define_identifier(opts[:force_default])
  end

  def to_s
    if @identifier.present?
      [ @namespace, @identifier, @attribute_name ].join(@separator)
    else
      [ @namespace, @attribute_name ].join(@separator)
    end
  end

  def is_default?
    @identifier == default_identifier
  end

  protected
  def default_identifier
    'default'
  end

  def define_namespace
    if localizable.class.respond_to?(:table_name)
      @namespace = localizable.class.table_name
    else
      @namespace = localizable.class.name.demodulize.tableize
    end
  end

  def define_identifier(force_default = false)
    if force_default
      return @identifer = default_identifier
    end

    if localizable.class < ActiveRecord::Base || localizable.respond_to?(:id)
      if localizable.id.present?
        @identifier = localizable.id
      else
        @identifier = default_identifier
      end
    end
  end
end
