from math import *

def pdata(radius, shrink, hratio, ori):
    print "  Radius: %f" % radius
    shrinked = radius * shrink
    print "  Shrinked: %f" % shrinked
    print "  Position:"
    ydown = (3 - hratio / 2) * radius
    print "    0: {%f, %f}" % (0.0, ydown)
    for i in xrange(1, 8):
        print "    %d: {%f, %f}" % (i, -sin(radians(angle * (i - 1))) * radius * 2, ydown - cos(radians(angle * (i - 1))) * radius * 2)
    print "---CODE---"
    for i in xrange(0, 8):
        print "constraint @%s %d width = NA 0 %d" % (ori, i, round(shrinked * 2))
        print "constraint @%s %d height = NA 0 %d" % (ori, i, round(shrinked * 2))
    print "constraint @%s 0 centerX = p centerX 1 0" % ori
    print "constraint @%s 0 centerY = p centerY 1 %d" % (ori, round(ydown))
    for i in xrange(1, 8):
        print "constraint @%s %d centerX = p centerX 1 %d" % (ori, i, round(-sin(radians(angle * (i - 1))) * radius * 2))
        print "constraint @%s %d centerY = p centerY 1 %d" % (ori, i, round(ydown - cos(radians(angle * (i - 1))) * radius * 2))
    print "---CODE---"

print "General"
inset = 20
print "  Inset: %d" % inset
shrink = 0.8
print "  Shrink: %f" % shrink
angle = 360.0 / 7
print "  Angle: %f" % angle
wratio = sin(radians(angle / 2 + angle)) * 4 + 2
print "  Width: %f r" % wratio
hratio = cos(radians(angle / 2)) * 2 + 4
print "  Height: %f r" % hratio
raw_input("...")
print
print "iPhone Landscape"
height = 272
rheight = height - inset * 2
print "  Height: %d - %d * 2 = %d" % (height, inset, rheight)
pdata(rheight / hratio, shrink, hratio, "landscape")
raw_input("...")
print
print "iPhone Portrait"
width = 320
rwidth = width - inset * 2
print "  Width: %d - %d * 2 = %d" % (width, inset, rwidth)
pdata(rwidth / wratio, shrink, hratio, "portrait")
raw_input("...")
print
print "iPad Landscape"
height = 720
rheight = height - inset * 2
print "  Height: %d - %d * 2 = %d" % (height, inset, rheight)
pdata(rheight / hratio, shrink, hratio, "landscape")
raw_input("...")
print
print "iPad Portrait"
width = 768
rwidth = width - inset * 2
print "  Width: %d - %d * 2 = %d" % (width, inset, rwidth)
pdata(rwidth / wratio, shrink, hratio, "portrait")
