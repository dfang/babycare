g1 = ExaminationGroup.create(name: "血液检查")
g2 = ExaminationGroup.create(name: "B超")
g3 = ExaminationGroup.create(name: "ECG")


Examination.create(name: '血常规', examination_group_id: g1)
Examination.create(name: 'C反应蛋白', examination_group_id: g1)


Examination.create(name: 'g', examination_group_id: g2)
Examination.create(name: 'C反应蛋白', examination_group_id: g2)


Examination.create(name: 'xx', examination_group_id: g3)
Examination.create(name: 'yyyyy', examination_group_id: g3)
