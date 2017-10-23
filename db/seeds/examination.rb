g1 = ExaminationGroup.create(name: "血液检查")
g2 = ExaminationGroup.create(name: "B超")
g3 = ExaminationGroup.create(name: "ECG")
g4 = ExaminationGroup.create(name: "X光")
g5 = ExaminationGroup.create(name: "CT平扫")
g6 = ExaminationGroup.create(name: "特殊感染性疾病检查列表")


Examination.create(name: '血常规', examination_group_id: g1.id)
Examination.create(name: 'C反应蛋白', examination_group_id: g1.id)
Examination.create(name: '支原体衣原体抗体检查', examination_group_id: g1.id)
Examination.create(name: '肝肾功能', examination_group_id: g1.id)
Examination.create(name: '尿常规', examination_group_id: g1.id)
Examination.create(name: '大便常规', examination_group_id: g1.id)
Examination.create(name: '降钙素原', examination_group_id: g1.id)

Examination.create(name: '肝胆胰脾B超', examination_group_id: g2.id)
Examination.create(name: '双肾输尿管膀胱B超', examination_group_id: g2.id)
Examination.create(name: '胸腔B超', examination_group_id: g2.id)

Examination.create(name: '十二导联心电图', examination_group_id: g3.id)

Examination.create(name: '胸部DR', examination_group_id: g4.id)
Examination.create(name: '骨骼DR', examination_group_id: g4.id)

Examination.create(name: '头部CT平扫', examination_group_id: g5.id)
Examination.create(name: '胸部CT平扫', examination_group_id: g5.id)
Examination.create(name: '腹部CT平扫', examination_group_id: g5.id)
Examination.create(name: '脑电图检查', examination_group_id: g5.id)

Examination.create(name: '呼吸道病毒咽拭子检查', examination_group_id: g6.id)
Examination.create(name: '肠道病毒检查', examination_group_id: g6.id)
