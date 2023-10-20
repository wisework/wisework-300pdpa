import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_model.dart';

final List<List<PurposeModel>> purposesPreset = [
  [
    PurposeModel.empty().copyWith(
      description: const [
        LocalizedModel(
          language: 'en-US',
          text:
              "This consent is necessary for preventing or addressing risks to an individual's life, body, or health, such as in the case of criminal activity.",
        ),
        LocalizedModel(
          language: 'th-TH',
          text:
              'ป้องกันหรือระงับอันตรายต่อชีวิต ร่างกาย หรือสุขภาพของบุคคล เช่น การก่ออาชญากรรม',
        ),
      ],
      warningDescription: const [
        LocalizedModel(
          language: 'en-US',
          text: '',
        ),
        LocalizedModel(
          language: 'th-TH',
          text: '',
        ),
      ],
      retentionPeriod: 2,
      periodUnit: 'y',
    ),
    PurposeModel.empty().copyWith(
      description: const [
        LocalizedModel(
          language: 'en-US',
          text:
              'For the legitimate interests of the company or other individuals or legal entities, such as mitigating unusual or emergency situations.',
        ),
        LocalizedModel(
          language: 'th-TH',
          text:
              'เพื่อประโยชน์อันชอบด้วยกฎหมายของบริษัท หรือของบุคคลหรือนิติบุคคลอื่น เช่น เพื่อระงับเหตุอันตราย เหตุการณ์ที่ไม่ปกติ หรือเหตุการณ์ฉุกเฉิน',
        ),
      ],
      warningDescription: const [
        LocalizedModel(
          language: 'en-US',
          text: '',
        ),
        LocalizedModel(
          language: 'th-TH',
          text: '',
        ),
      ],
      retentionPeriod: 2,
      periodUnit: 'y',
    ),
  ],
  [
    PurposeModel.empty().copyWith(
      description: const [
        LocalizedModel(
          language: 'en-US',
          text:
              'This consent is required for the purpose of recruiting and selecting employees.',
        ),
        LocalizedModel(
          language: 'th-TH',
          text: 'เพื่อวัตถุประสงค์ในการสรรหาและคัดเลือกพนักงาน',
        ),
      ],
      warningDescription: const [
        LocalizedModel(
          language: 'en-US',
          text: '',
        ),
        LocalizedModel(
          language: 'th-TH',
          text: '',
        ),
      ],
      retentionPeriod: 2,
      periodUnit: 'y',
    ),
    PurposeModel.empty().copyWith(
      description: const [
        LocalizedModel(
          language: 'en-US',
          text:
              'To execute contracts and fulfill obligations under the contract between you and the agency.',
        ),
        LocalizedModel(
          language: 'th-TH',
          text:
              'เพื่อการเข้าทำสัญญาและ/หรือการปฏิบัติหน้าที่ตามสัญญาที่ท่านได้ทำไว้กับหน่วยงาน',
        ),
      ],
      warningDescription: const [
        LocalizedModel(
          language: 'en-US',
          text: '',
        ),
        LocalizedModel(
          language: 'th-TH',
          text: '',
        ),
      ],
      retentionPeriod: 2,
      periodUnit: 'y',
    ),
    PurposeModel.empty().copyWith(
      description: const [
        LocalizedModel(
          language: 'en-US',
          text:
              'For communication, to schedule job interviews, and to streamline the recruitment process.',
        ),
        LocalizedModel(
          language: 'th-TH',
          text:
              'เพื่อการติดต่อสื่อสาร เพื่อการนัดหมายการสัมภาษณ์งาน อำนวยความสะดวกในกระบวนการสรรหา',
        ),
      ],
      warningDescription: const [
        LocalizedModel(
          language: 'en-US',
          text: '',
        ),
        LocalizedModel(
          language: 'th-TH',
          text: '',
        ),
      ],
      retentionPeriod: 2,
      periodUnit: 'y',
    ),
    PurposeModel.empty().copyWith(
      description: const [
        LocalizedModel(
          language: 'en-US',
          text:
              'For accessing services or participating in various agency activities.',
        ),
        LocalizedModel(
          language: 'th-TH',
          text: 'เพื่อการเข้าใช้บริการหรือเข้าร่วมกิจกรรมต่าง ๆ ของหน่วยงาน',
        ),
      ],
      warningDescription: const [
        LocalizedModel(
          language: 'en-US',
          text: '',
        ),
        LocalizedModel(
          language: 'th-TH',
          text: '',
        ),
      ],
      retentionPeriod: 2,
      periodUnit: 'y',
    ),
    PurposeModel.empty().copyWith(
      description: const [
        LocalizedModel(
          language: 'en-US',
          text:
              "To compile data in the company's database and gather statistical information about the recruitment channels.",
        ),
        LocalizedModel(
          language: 'th-TH',
          text:
              'เพื่อรวบรวมข้อมูลเป็นฐานข้อมูลของบริษัทหรือข้อมูลเชิงสถิติเกี่ยวกับจํานวนผู้ทราบข่าวการรับสมัครในแต่ละช่องทาง',
        ),
      ],
      warningDescription: const [
        LocalizedModel(
          language: 'en-US',
          text: '',
        ),
        LocalizedModel(
          language: 'th-TH',
          text: '',
        ),
      ],
      retentionPeriod: 2,
      periodUnit: 'y',
    ),
  ],
  [
    PurposeModel.empty().copyWith(
      description: const [
        LocalizedModel(
          language: 'en-US',
          text: 'To facilitate the development of services.',
        ),
        LocalizedModel(
          language: 'th-TH',
          text: 'เพื่ออำนวยความสะดวก และพัฒนาการใช้บริการ',
        ),
      ],
      warningDescription: const [
        LocalizedModel(
          language: 'en-US',
          text: '',
        ),
        LocalizedModel(
          language: 'th-TH',
          text: '',
        ),
      ],
      retentionPeriod: 2,
      periodUnit: 'y',
    ),
    PurposeModel.empty().copyWith(
      description: const [
        LocalizedModel(
          language: 'en-US',
          text:
              "To enhance the company's services, cater to user needs, and improve user satisfaction.",
        ),
        LocalizedModel(
          language: 'th-TH',
          text:
              'เพื่อปรับปรุงบริการฯ ของบริษัท และตอบสนองต่อความต้องการ และความพึงพอใจของผู้ใช้',
        ),
      ],
      warningDescription: const [
        LocalizedModel(
          language: 'en-US',
          text: '',
        ),
        LocalizedModel(
          language: 'th-TH',
          text: '',
        ),
      ],
      retentionPeriod: 2,
      periodUnit: 'y',
    ),
    PurposeModel.empty().copyWith(
      description: const [
        LocalizedModel(
          language: 'en-US',
          text:
              "To offer and provide products, services, discounts, or promotions from the company, its affiliates, and the company's trading partners.",
        ),
        LocalizedModel(
          language: 'th-TH',
          text:
              'เพื่อเสนอและให้สินค้า บริการ ส่วนลด หรือโปรโมชั่นจากบริษัท และ/หรือบริษัทในเครือ และคู่ค้าของบริษัท',
        ),
      ],
      warningDescription: const [
        LocalizedModel(
          language: 'en-US',
          text: '',
        ),
        LocalizedModel(
          language: 'th-TH',
          text: '',
        ),
      ],
      retentionPeriod: 2,
      periodUnit: 'y',
    ),
    PurposeModel.empty().copyWith(
      description: const [
        LocalizedModel(
          language: 'en-US',
          text:
              'To conduct market analysis and advertising targeting specific groups, while modernizing service improvements and promotional offerings.',
        ),
        LocalizedModel(
          language: 'th-TH',
          text:
              'เพื่อวิเคราะห์ ทำการตลาด และทำการโฆษณาตามกลุ่มเป้าหมาย รวมถึงปรับปรุงการให้บริการและข้อเสนอส่งเสริมการขายให้ทันสมัยยิ่งขึ้น',
        ),
      ],
      warningDescription: const [
        LocalizedModel(
          language: 'en-US',
          text: '',
        ),
        LocalizedModel(
          language: 'th-TH',
          text: '',
        ),
      ],
      retentionPeriod: 2,
      periodUnit: 'y',
    ),
    PurposeModel.empty().copyWith(
      description: const [
        LocalizedModel(
          language: 'en-US',
          text:
              'For research and other analytical purposes, involving the study and comprehension of service access and usage patterns.',
        ),
        LocalizedModel(
          language: 'th-TH',
          text:
              'เพื่อวัตถุประสงค์ที่เกี่ยวกับการค้นคว้า และการวิเคราะห์อื่นๆ โดยการศึกษาและทำความเข้าใจการเข้าถึงบริการและใช้บริการฯ ของบริษัท',
        ),
      ],
      warningDescription: const [
        LocalizedModel(
          language: 'en-US',
          text: '',
        ),
        LocalizedModel(
          language: 'th-TH',
          text: '',
        ),
      ],
      retentionPeriod: 2,
      periodUnit: 'y',
    ),
  ],
  [
    PurposeModel.empty().copyWith(
      description: const [
        LocalizedModel(
          language: 'en-US',
          text:
              "To provide services that cater to the customer's needs, the company will use customers' personal information. This enables customers to receive products and/or services aligned with their contractual agreement or specific requests.",
        ),
        LocalizedModel(
          language: 'th-TH',
          text:
              'เพื่อบริการให้ตรงตามต้องการของลูกค้า บริษัทจะใช้ข้อมูลส่วนบุคคลของลูกค้า เพื่อที่ลูกค้าจะสามารถได้รับผลิตภัณฑ์และ/หรือบริการที่ตรงตามวัตถุประสงค์ของลูกค้าตามสัญญาหรือตามที่ลูกค้าร้องขอ',
        ),
      ],
      warningDescription: const [
        LocalizedModel(
          language: 'en-US',
          text: '',
        ),
        LocalizedModel(
          language: 'th-TH',
          text: '',
        ),
      ],
      retentionPeriod: 2,
      periodUnit: 'y',
    ),
    PurposeModel.empty().copyWith(
      description: const [
        LocalizedModel(
          language: 'en-US',
          text:
              'For legitimate interests or to comply with the law, including exceptions as per the Personal Data Protection Act.',
        ),
        LocalizedModel(
          language: 'th-TH',
          text:
              'เพื่อประโยชน์โดยชอบด้วยกฎหมาย หรือ เพื่อปฏิบัติตามกฎหมาย หรือ ข้อยกเว้นตามกฎหมาย ไม่ว่าตามพระราชบัญญัติคุ้มครองข้อมูลส่วนบุคคลหรือกฎหมายใด ๆ',
        ),
      ],
      warningDescription: const [
        LocalizedModel(
          language: 'en-US',
          text: '',
        ),
        LocalizedModel(
          language: 'th-TH',
          text: '',
        ),
      ],
      retentionPeriod: 2,
      periodUnit: 'y',
    ),
    PurposeModel.empty().copyWith(
      description: const [
        LocalizedModel(
          language: 'en-US',
          text:
              'In line with the legitimate interests of the company or another individual or legal entity.',
        ),
        LocalizedModel(
          language: 'th-TH',
          text:
              'เพื่อประโยชน์โดยชอบด้วยกฎหมายของบริษัท หรือของบุคคลหรือนิติบุคคลอื่น',
        ),
      ],
      warningDescription: const [
        LocalizedModel(
          language: 'en-US',
          text: '',
        ),
        LocalizedModel(
          language: 'th-TH',
          text: '',
        ),
      ],
      retentionPeriod: 2,
      periodUnit: 'y',
    ),
    PurposeModel.empty().copyWith(
      description: const [
        LocalizedModel(
          language: 'en-US',
          text:
              'To enable customers to benefit from using products and/or services for which they have provided consent.',
        ),
        LocalizedModel(
          language: 'th-TH',
          text:
              'เพื่อให้ลูกค้าได้รับประโยชน์จากการใช้ผลิตภัณฑ์และ/หรือบริการ ตามที่ลูกค้าได้ให้ความยินยอมไว้',
        ),
      ],
      warningDescription: const [
        LocalizedModel(
          language: 'en-US',
          text: '',
        ),
        LocalizedModel(
          language: 'th-TH',
          text: '',
        ),
      ],
      retentionPeriod: 2,
      periodUnit: 'y',
    ),
  ],
  [
    PurposeModel.empty().copyWith(
      description: const [
        LocalizedModel(
          language: 'en-US',
          text:
              "This consent is necessary to provide information for accessing the organization's intranet system.",
        ),
        LocalizedModel(
          language: 'th-TH',
          text: 'เพื่อเป็นข้อมูลสำหรับเข้าใช้งานระบบ Intranet ภายในองค์กร',
        ),
      ],
      warningDescription: const [
        LocalizedModel(
          language: 'en-US',
          text: '',
        ),
        LocalizedModel(
          language: 'th-TH',
          text: '',
        ),
      ],
      retentionPeriod: 2,
      periodUnit: 'y',
    ),
    PurposeModel.empty().copyWith(
      description: const [
        LocalizedModel(
          language: 'en-US',
          text: 'For work-related tasks or contractual obligations.',
        ),
        LocalizedModel(
          language: 'th-TH',
          text: 'เพื่อการปฏิบัติงาน หรือหน้าที่ตามที่ได้ทำสัญญาไว้',
        ),
      ],
      warningDescription: const [
        LocalizedModel(
          language: 'en-US',
          text: '',
        ),
        LocalizedModel(
          language: 'th-TH',
          text: '',
        ),
      ],
      retentionPeriod: 2,
      periodUnit: 'y',
    ),
    PurposeModel.empty().copyWith(
      description: const [
        LocalizedModel(
          language: 'en-US',
          text: 'To confirm the identity of the personal data owner.',
        ),
        LocalizedModel(
          language: 'th-TH',
          text: 'เพื่อยืนยันตัวตนเจ้าของข้อมูลส่วนบุคคล',
        ),
      ],
      warningDescription: const [
        LocalizedModel(
          language: 'en-US',
          text: '',
        ),
        LocalizedModel(
          language: 'th-TH',
          text: '',
        ),
      ],
      retentionPeriod: 2,
      periodUnit: 'y',
    ),
    PurposeModel.empty().copyWith(
      description: const [
        LocalizedModel(
          language: 'en-US',
          text:
              'For accessing services or participating in various agency activities.',
        ),
        LocalizedModel(
          language: 'th-TH',
          text: 'เพื่อการเข้าใช้บริการหรือเข้าร่วมกิจกรรมต่าง ๆ ของหน่วยงาน',
        ),
      ],
      warningDescription: const [
        LocalizedModel(
          language: 'en-US',
          text: '',
        ),
        LocalizedModel(
          language: 'th-TH',
          text: '',
        ),
      ],
      retentionPeriod: 2,
      periodUnit: 'y',
    ),
  ],
  [
    PurposeModel.empty().copyWith(
      description: const [
        LocalizedModel(
          language: 'en-US',
          text:
              'This consent is required to confirm your identity through identification documents, such as an ID card, passport, or any other document issued by your government agency.',
        ),
        LocalizedModel(
          language: 'th-TH',
          text:
              'เพื่อใช้สำหรับยืนยันตัวตนของท่าน กรณีที่เอกสารระบุตัวตน (เช่น บัตรประชาชน หนังสือเดินทาง หรือเอกสารอื่นใดที่ออกโดยหน่วยงานราชการ) ของท่าน',
        ),
      ],
      warningDescription: const [
        LocalizedModel(
          language: 'en-US',
          text: '',
        ),
        LocalizedModel(
          language: 'th-TH',
          text: '',
        ),
      ],
      retentionPeriod: 2,
      periodUnit: 'y',
    ),
    PurposeModel.empty().copyWith(
      description: const [
        LocalizedModel(
          language: 'en-US',
          text:
              'It is essential for the purposes of delivering services to you.',
        ),
        LocalizedModel(
          language: 'th-TH',
          text: 'เพื่่อวัตถุประสงค์ที่จำเป็นเพื่อการให้บริการแก่ท่าน',
        ),
      ],
      warningDescription: const [
        LocalizedModel(
          language: 'en-US',
          text: '',
        ),
        LocalizedModel(
          language: 'th-TH',
          text: '',
        ),
      ],
      retentionPeriod: 2,
      periodUnit: 'y',
    ),
  ],
];
