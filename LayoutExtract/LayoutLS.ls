position 0
position 1
position 2
position 3
position 4
position 5
position 6
position 7

constraint 0 width = 1 width 1 0
constraint 0 height = 1 height 1 0
constraint 0 width = 2 width 1 0
constraint 0 height = 2 height 1 0
constraint 0 width = 3 width 1 0
constraint 0 height = 3 height 1 0
constraint 0 width = 4 width 1 0
constraint 0 height = 4 height 1 0
constraint 0 width = 5 width 1 0
constraint 0 height = 5 height 1 0
constraint 0 width = 6 width 1 0
constraint 0 height = 6 height 1 0
constraint 0 width = 7 width 1 0
constraint 0 height = 7 height 1 0
constraint 0 width = 0 height 1 0
constraint 0 centerX = 1 centerX 1 0
constraint 0 centerX = 2 centerX 1 0
constraint 4 centerX = 5 centerX 1 0
constraint 4 centerX = 6 centerX 1 0
constraint 0 centerY = 6 centerY 1 0
constraint 0 centerY = 7 centerY 1 0
constraint 2 centerY = 3 centerY 1 0
constraint 2 centerY = 4 centerY 1 0
constraint 0 bottom = 1 top 1 -8
constraint 1 bottom = 2 top 1 -8
constraint 6 bottom = 5 top 1 -8
constraint 5 bottom = 4 top 1 -8
constraint 0 right = 7 left 1 -8
constraint 7 right = 6 left 1 -8
constraint 2 right = 3 left 1 -8
constraint 3 right = 4 left 1 -8
constraint @p 999 0 left = p left 1 20
constraint @p 999 0 top = p top 1 20
constraint @p 999 4 right = p right 1 -20
constraint @p 999 4 bottom = p bottom 1 -20
constraint 0 left >= p left 1 20
constraint 0 top >= p top 1 20
constraint 4 right <= p right 1 -20
constraint 4 bottom <= p bottom 1 -20
constraint 7 centerX = p centerX 1 0
constraint 1 centerY = p centerY 1 0

cornerRadius * 15