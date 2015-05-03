class SentimentAnalyser::BigramAssociationMeasures


=begin
          w1    ~w1
         ------ ------
     w2 | n_ii | n_oi | = n_xi
         ------ ------
    ~w2 | n_io | n_oo | = n_xo
         ------ ------
         = n_ix =n_ox  TOTAL = n_xx
=end

  def initialize(n_ii, n_xi, n_ix,n_xx)
    @n_ii = n_ii
    @n_xi = n_xi
    @n_ix = n_ix
    @n_xx = n_xx
  end


  def contingency_table
    return @contingency_table if @contingency_table

    n_oi = @n_xi - @n_ii
    n_io = @n_ix - @n_ii
    n_xo = @n_xx - @n_xi
    n_ox = @n_xx - @n_ix
    n_oo = n_ox - n_oi

    @contingency_table = [[@n_ii, n_oi, @n_xi]] +
                         [[n_io,  n_oo, n_xo ]] +
                         [[@n_ix, n_ox, @n_xx]]
  end

  def expected_values
    return @expected_values if @expected_values

    values = [[],[]]

    2.times do |i|
      2.times do |j|
        values[i][j] = (contingency_table[i][2]*contingency_table[2][j])/contingency_table[2][2].to_f
      end
    end

    @expected_values = values
  end

  def chi_square
    sum = 0
    2.times do |i|
      2.times do |j|
        sum += ((contingency_table[i][j]-expected_values[i][j])**2) / expected_values[i][j]
      end
    end
    sum
  end


  def zscore
    n1 = @n_ii + contingency_table[2][0].to_f
    pf = (@n_ii + contingency_table[0][1]).to_f / contingency_table[2][2].to_f

    a = @n_ii - n1 * pf
    b = Math.sqrt(n1 * pf * (1-pf))

    a/b
  end
end