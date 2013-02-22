class Board < ActiveRecord::Base

  NumCount = 0
  BoardTypes = [:small, :medium, :big]

  validates :board_nums, presence: true
  validate :validates_uniqueness_of_board_nums

  after_initialize :init_board!, unless: :board_nums

  class << self
    def dimension
      @dimension ||= begin
        (self::NumCount ** 0.5).to_i rescue 0
      end.freeze
    end

    def all_nums
      @all_nums ||= begin
        (1..self::NumCount).to_a rescue nil
      end.freeze
    end

    def generate_nums
      all_nums.dup.shuffle.join(',')
    end

    def available_boards
      BoardTypes
    end

    def default_board
      :medium
    end
  end

  def board_nums
    self[:board_nums].split(',').map(&:to_i).in_groups_of(self.class.dimension) rescue nil
  end

  def check_number(opts={})
    ind = opts.fetch :index
    num = opts.fetch :number
    self.board_nums.flatten[ind] == num
  end

  private

  def init_board!
    self[:board_nums] = self.class.generate_nums
  end

  def validates_uniqueness_of_board_nums
    boards = self.class
    boards = boards.where("id <> ?", self.id) if self.persisted?
    self.errors[:base] << 'There is already board with such numbers combination!' if boards.find_by_board_nums(self.read_attribute :board_nums)
  end

end
