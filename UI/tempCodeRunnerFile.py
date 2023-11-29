for c,i in enumerate(px):
#     if '.png' in filename and pixels[c] == 0:
#         C.append(0)
#     elif i in D.keys():
#         C.append(D[i])
#     else:
#         MIN = (255, 255, 255)
#         MINK = (255, 255, 255)
#         for k in D.keys():
#             if abs(k[0] - i[0]) + abs(k[1] - i[1]) + abs(k[2] - i[2]) < MIN[0] + MIN[1] + MIN[2]:
#                 MIN = (abs(k[0] - i[0]), abs(k[1] - i[1]), abs(k[2] - i[2]))
#                 MINK = k
#         C.append(D[MINK])