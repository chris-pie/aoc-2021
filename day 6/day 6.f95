program main
  implicit none
  integer(KIND=8) :: fsize, re_i, numc, i, j, cycle_length, maturity_length, curr_cycle, last_cycle, fish_sum
  integer(KIND=8), dimension(:), allocatable :: in_num, cycles, maturing
  character(len=:), allocatable :: mystr
  cycle_length = 7
  maturity_length = 3
  inquire(FILE='day 6.txt', size=fsize)
  allocate(character(fsize) :: mystr)
  open (69, file='day 6.txt')
  read(69, '(A)') mystr
  numc = countsubstring(mystr, ",")
  allocate (in_num(numc + 1))
  rewind 69
  read(69, *) in_num
  allocate(cycles(cycle_length))
  allocate(maturing(maturity_length))
  maturing = 0
  cycles = 0
  do i = 1, numc + 1
    cycles(in_num(i)+1) = cycles(in_num(i)+1) + 1
  end do
  do i = 1, 255
    curr_cycle = modulo(i, cycle_length) + 1
    last_cycle = modulo(i - 1, cycle_length) + 1
    cycles(last_cycle) = cycles(last_cycle) + maturing(1)
    do j = 1, maturity_length - 1
        maturing(j) = maturing(j+1)
    end do
    maturing(maturity_length) = cycles(curr_cycle)
    if (i .eq. 79) then
        fish_sum = sum(cycles) + sum(maturing)
        write (*,*) fish_sum
    end if
  end do
  fish_sum = sum(cycles) + sum(maturing)
  write (*,*) fish_sum
  re_i = system("pause")

contains
    function countsubstring(s1, s2) result(c)
      character(*), intent(in) :: s1, s2
      integer :: c, p, posn

      c = 0
      if(len(s2) == 0) return
      p = 1
      do
        posn = index(s1(p:), s2)
        if(posn == 0) return
        c = c + 1
        p = p + posn + len(s2)
      end do
    end function
endprogram
