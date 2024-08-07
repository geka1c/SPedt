#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Имена видов объектов.

// Печатная форма.
//
// Возвращаемое значение:
//   Строка - Имя вида дополнительных печатных форм.
//
Функция ВидОбработкиПечатнаяФорма() Экспорт
	
	Возврат "ПечатнаяФорма"; // Внутренний идентификатор.
	
КонецФункции

// Заполнение объекта.
//
// Возвращаемое значение:
//   Строка - Имя вида дополнительных обработок заполнения.
//
Функция ВидОбработкиЗаполнениеОбъекта() Экспорт
	
	Возврат "ЗаполнениеОбъекта"; // Внутренний идентификатор.
	
КонецФункции

// Создание связанных объектов.
//
// Возвращаемое значение:
//   Строка - Имя вида дополнительных обработок создания связанных объектов.
//
Функция ВидОбработкиСозданиеСвязанныхОбъектов() Экспорт
	
	Возврат "СозданиеСвязанныхОбъектов"; // Внутренний идентификатор.
	
КонецФункции

// Назначаемый отчет.
//
// Возвращаемое значение:
//   Строка - Имя вида дополнительных контекстных отчетов.
//
Функция ВидОбработкиОтчет() Экспорт
	
	Возврат "Отчет"; // Внутренний идентификатор.
	
КонецФункции

// Создание связанных объектов.
//
// Возвращаемое значение:
//   Строка - Имя вида дополнительных контекстных отчетов.
//
Функция ВидОбработкиШаблонСообщения() Экспорт
	
	Возврат "ШаблонСообщения"; // Внутренний идентификатор.
	
КонецФункции

// Дополнительная обработка.
//
// Возвращаемое значение:
//   Строка - Имя вида дополнительных глобальных обработок.
//
Функция ВидОбработкиДополнительнаяОбработка() Экспорт
	
	Возврат "ДополнительнаяОбработка"; // Внутренний идентификатор.
	
КонецФункции

// Дополнительный отчет.
//
// Возвращаемое значение:
//   Строка - Имя вида дополнительных глобальных отчетов.
//
Функция ВидОбработкиДополнительныйОтчет() Экспорт
	
	Возврат "ДополнительныйОтчет"; // Внутренний идентификатор.
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Имена типов команд.

// Возвращает имя типа команд с вызовом серверного метода. Для выполнения команд такого типа
//   в модуле объекта следует определить экспортную процедуру по шаблону:
//   
//   Для глобальных отчетов и обработок (Вид = "ДополнительнаяОбработка" или Вид = "ДополнительныйОтчет"):
//       // Обработчик серверных команд.
//       //
//       // Параметры:
//       //   ИдентификаторКоманды - Строка    - Имя команды, определенное в функции СведенияОВнешнейОбработке().
//       //   ПараметрыВыполнения  - Структура - Контекст выполнения команды.
//       //       * ДополнительнаяОбработкаСсылка - СправочникСсылка.ДополнительныеОтчетыИОбработки - Ссылка обработки.
//       //           Может использоваться для чтения параметров обработки.
//       //           Пример см. в комментарии к функции ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыОткрытиеФормы().
//       //       * РезультатВыполнения - Структура - Результат выполнения команды.
//       //           Может использоваться для передачи результата с сервера или из фонового задания в исходную точку.
//       //           В частности, возвращается функциями ДополнительныеОтчетыИОбработки.ВыполнитьКоманду()
//       //           и ДополнительныеОтчетыИОбработки.ВыполнитьКомандуИзФормыВнешнегоОбъекта(),
//       //           а также может быть получено из временного хранилища
//       //           в обработчике ожидания процедуры ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьКомандуВФоне().
//       //
//       Процедура ВыполнитьКоманду(ИдентификаторКоманды, ПараметрыВыполнения) Экспорт
//       	// Реализация логики команды.
//       КонецПроцедуры
//   
//   Для печатных форм (Вид = "ПечатнаяФорма"):
//       // Обработчик печати.
//       //
//       // Параметры:
//       //   МассивОбъектов - Массив - Ссылки на объекты, которые нужно распечатать.
//       //   КоллекцияПечатныхФорм - ТаблицаЗначений - Информация о табличных документах.
//       //       Используется для передачи в параметрах функции УправлениеПечатью.СведенияОПечатнойФорме().
//       //   ОбъектыПечати - СписокЗначений - Соответствие между объектами и именами областей в табличных документах.
//       //       Используется для передачи в параметрах процедуры УправлениеПечатью.ЗадатьОбластьПечатиДокумента().
//       //   ПараметрыВывода - Структура - Дополнительные параметры сформированных табличных документов.
//       //       * ДополнительнаяОбработкаСсылка - СправочникСсылка.ДополнительныеОтчетыИОбработки - Ссылка обработки.
//       //           Может использоваться для чтения параметров обработки.
//       //           Пример см. в комментарии к функции ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыОткрытиеФормы().
//       //
//       // Пример:
//       //  	ПечатнаяФорма = УправлениеПечатью.СведенияОПечатнойФорме(КоллекцияПечатныхФорм, "<ИдентификаторПечатнойФормы>");
//       //  	Если ПечатнаяФорма <> Неопределено Тогда
//       //  		ТабличныйДокумент = Новый ТабличныйДокумент;
//       //  		ТабличныйДокумент.КлючПараметровПечати = "<КлючСохраненияПараметровПечатнойФормы>";
//       //  		Для Каждого Ссылка Из МассивОбъектов Цикл
//       //  			Если ТабличныйДокумент.ВысотаТаблицы > 0 Тогда
//       //  				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
//       //  			КонецЕсли;
//       //  			НачалоОбласти = ТабличныйДокумент.ВысотаТаблицы + 1;
//       //  			// ... код по формированию табличного документа ...
//       //  			УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НачалоОбласти, ОбъектыПечати, Ссылка);
//       //  		КонецЦикла;
//       //  		ПечатнаяФорма.ТабличныйДокумент = ТабличныйДокумент;
//       //  	КонецЕсли;
//       //
//       Процедура Печать(МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
//       	// Реализация логики команды.
//       КонецПроцедуры
//   
//   Для обработок создания связанных объектов (Вид = "СозданиеСвязанныхОбъектов"):
//       // Обработчик серверных команд.
//       //
//       // Параметры:
//       //   ИдентификаторКоманды - Строка - Имя команды, определенное в функции СведенияОВнешнейОбработке().
//       //   ОбъектыНазначения    - Массив - Ссылки объектов, для которых вызвана команда.
//       //   СозданныеОбъекты     - Массив - Ссылки новых объектов, созданных в результате выполнения команды.
//       //   ПараметрыВыполнения  - Структура - Контекст выполнения команды.
//       //       * ДополнительнаяОбработкаСсылка - СправочникСсылка.ДополнительныеОтчетыИОбработки - Ссылка обработки.
//       //           Может использоваться для чтения параметров обработки.
//       //           Пример см. в комментарии к функции ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыОткрытиеФормы().
//       //       * РезультатВыполнения - Структура - Результат выполнения команды.
//       //           Может использоваться для передачи результата с сервера или из фонового задания в исходную точку.
//       //           В частности, возвращается функциями ДополнительныеОтчетыИОбработки.ВыполнитьКоманду()
//       //           и ДополнительныеОтчетыИОбработки.ВыполнитьКомандуИзФормыВнешнегоОбъекта(),
//       //           а также может быть получено из временного хранилища
//       //           в обработчике ожидания процедуры ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьКомандуВФоне().
//       //
//       Процедура ВыполнитьКоманду(ИдентификаторКоманды, ОбъектыНазначения, СозданныеОбъекты, ПараметрыВыполнения) Экспорт
//       	// Реализация логики команды.
//       КонецПроцедуры
//   
//   Для обработок заполнения (Вид = "ЗаполнениеОбъекта"):
//       // Обработчик серверных команд.
//       //
//       // Параметры:
//       //   ИдентификаторКоманды - Строка - Имя команды, определенное в функции СведенияОВнешнейОбработке().
//       //   ОбъектыНазначения    - Массив - Ссылки объектов, для которых вызвана команда.
//       //       - Неопределено - для команд "ЗаполнениеФормы".
//       //   ПараметрыВыполнения  - Структура - Контекст выполнения команды.
//       //       * ДополнительнаяОбработкаСсылка - СправочникСсылка.ДополнительныеОтчетыИОбработки - Ссылка обработки.
//       //           Может использоваться для чтения параметров обработки.
//       //           Пример см. в комментарии к функции ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыОткрытиеФормы().
//       //       * РезультатВыполнения - Структура - Результат выполнения команды.
//       //           Может использоваться для передачи результата с сервера или из фонового задания в исходную точку.
//       //           В частности, возвращается функциями ДополнительныеОтчетыИОбработки.ВыполнитьКоманду()
//       //           и ДополнительныеОтчетыИОбработки.ВыполнитьКомандуИзФормыВнешнегоОбъекта(),
//       //           а также может быть получено из временного хранилища
//       //           в обработчике ожидания процедуры ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьКомандуВФоне().
//       //
//       Процедура ВыполнитьКоманду(ИдентификаторКоманды, ОбъектыНазначения, ПараметрыВыполнения) Экспорт
//       	// Реализация логики команды.
//       КонецПроцедуры
//
// Возвращаемое значение:
//   Строка - имя типа команд с вызовом серверного метода.
//
Функция ТипКомандыВызовСерверногоМетода() Экспорт
	
	Возврат "ВызовСерверногоМетода"; // Внутренний идентификатор.
	
КонецФункции

// Возвращает имя типа команд с вызовом клиентского метода. Для выполнения команд такого типа
//   в основной форме внешнего объекта следует определить клиентскую экспортную процедуру по шаблону:
//   
//   Для глобальных отчетов и обработок (Вид = "ДополнительнаяОбработка" или Вид = "ДополнительныйОтчет"):
//       &НаКлиенте
//       Процедура ВыполнитьКоманду(ИдентификаторКоманды) Экспорт
//       	// Реализация логики команды.
//       КонецПроцедуры
//   
//   Для печатных форм (Вид = "ПечатнаяФорма"):
//       &НаКлиенте
//       Процедура Печать(ИдентификаторКоманды, ОбъектыНазначенияМассив) Экспорт
//       	// Реализация логики команды.
//       КонецПроцедуры
//   
//   Для обработок создания связанных объектов (Вид = "СозданиеСвязанныхОбъектов"):
//       &НаКлиенте
//       Процедура ВыполнитьКоманду(ИдентификаторКоманды, ОбъектыНазначенияМассив, СозданныеОбъекты) Экспорт
//       	// Реализация логики команды.
//       КонецПроцедуры
//   
//   Для обработок заполнения и контекстных отчетов (Вид = "ЗаполнениеОбъекта" или Вид = "Отчет"):
//       &НаКлиенте
//       Процедура ВыполнитьКоманду(ИдентификаторКоманды, ОбъектыНазначенияМассив) Экспорт
//       	// Реализация логики команды.
//       КонецПроцедуры
//   
//   Дополнительно (для всех видов):
//     В параметре формы "ДополнительнаяОбработкаСсылка" передается ссылка этого объекта
//     (элемент справочника ДополнительныеОтчетыИОбработки, соответствующий этому объекту),
//     которая может использоваться для фонового выполнения длительных операций.
//     Подробнее см. в документации к подсистеме, раздел "Фоновое выполнение длительных операций".
//
// Возвращаемое значение:
//   Строка - имя типа команд с вызовом клиентского метода.
//
Функция ТипКомандыВызовКлиентскогоМетода() Экспорт
	
	Возврат "ВызовКлиентскогоМетода"; // Внутренний идентификатор.
	
КонецФункции

// Возвращает имя типа команд по открытию формы. При выполнении этих команд
//   открывается основная форма внешнего объекта с указанными ниже параметрами.
//
//   Общие параметры:
//       * ИдентификаторКоманды - Строка - Имя команды, определенное в функции СведенияОВнешнейОбработке().
//       * ДополнительнаяОбработкаСсылка - СправочникСсылка.ДополнительныеОтчетыИОбработки - Ссылка этого объекта.
//           Может использоваться для чтения и сохранения параметров обработки.
//           Также может использоваться для фонового выполнения длительных операций.
//           Подробнее см. в документации к подсистеме, раздел "Фоновое выполнение длительных операций".
//       * ИмяФормы - Строка - Имя формы-владельца, из которой вызвана эта команда.
//   
//   Вспомогательные параметры для обработок создания связанных объектов (Вид = "СозданиеСвязанныхОбъектов"),
//   обработок заполнения (Вид = "ЗаполнениеОбъекта") и контекстных отчетов (Вид = "Отчет"):
//       * ОбъектыНазначения - Массив - Ссылки объектов, для которых вызвана команда.
//   
//   Пример чтения общих параметров:
//       	ОбъектСсылка = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Параметры, "ДополнительнаяОбработкаСсылка");
//       	ИдентификаторКоманды = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Параметры, "ИдентификаторКоманды");
//   
//   Пример чтения значений дополнительных настроек:
//       	Если ЗначениеЗаполнено(ОбъектСсылка) Тогда
//       		ХранилищеНастроек = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОбъектСсылка, "ХранилищеНастроек");
//       		Настройки = ХранилищеНастроек.Получить();
//       		Если ТипЗнч(Настройки) = Тип("Структура") Тогда
//       			ЗаполнитьЗначенияСвойств(ЭтотОбъект, "<ИменаНастроек>");
//       		КонецЕсли;
//       	КонецЕсли;
//   
//   Пример сохранения значений дополнительных настроек:
//       	Настройки = Новый Структура("<ИменаНастроек>", <ЗначенияНастроек>);
//       	ДополнительнаяОбработкаОбъект = ОбъектСсылка.ПолучитьОбъект();
//       	ДополнительнаяОбработкаОбъект.ХранилищеНастроек = Новый ХранилищеЗначения(Настройки);
//       	ДополнительнаяОбработкаОбъект.Записать();
//
// Возвращаемое значение:
//   Строка - имя типа команд по открытию формы.
//
Функция ТипКомандыОткрытиеФормы() Экспорт
	
	Возврат "ОткрытиеФормы"; // Внутренний идентификатор.
	
КонецФункции

// Возвращает имя типа команд по заполнению формы без записи объекта. Данные команды доступны
//   только в обработках заполнения (Вид = "ЗаполнениеОбъекта").
//   Для выполнения команд такого типа в модуле объекта следует определить экспортную процедуру по шаблону:
//       // Обработчик серверных команд.
//       //
//       // Параметры:
//       //   ИдентификаторКоманды - Строка - Имя команды, определенное в функции СведенияОВнешнейОбработке().
//       //   ОбъектыНазначения    - Массив - Ссылки объектов, для которых вызвана команда.
//       //       - Неопределено - Не передается для команд типа "ЗаполнениеФормы".
//       //   ПараметрыВыполнения  - Структура - Контекст выполнения команды.
//       //       * ЭтаФорма - УправляемаяФорма - Заполняемая форма. Передается для команд типа "ЗаполнениеФормы".
//       //       * ДополнительнаяОбработкаСсылка - СправочникСсылка.ДополнительныеОтчетыИОбработки - Ссылка обработки.
//       //           Может использоваться для чтения параметров обработки.
//       //           Пример см. в комментарии к функции ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыОткрытиеФормы().
//       //
//       Процедура ВыполнитьКоманду(ИдентификаторКоманды, ОбъектыНазначения, ПараметрыВыполнения) Экспорт
//       	// Реализация логики команды.
//       КонецПроцедуры
//
// Возвращаемое значение:
//   Строка - имя типа команд по заполнению формы.
//
Функция ТипКомандыЗаполнениеФормы() Экспорт
	
	Возврат "ЗаполнениеФормы"; // Внутренний идентификатор.
	
КонецФункции

// Возвращает имя типа команд по сценарному выполнению в безопасном режиме.
//   Для выполнения команд такого типа в модуле объекта следует определить экспортную процедуру по шаблону:
//       // Формирование сценария выполнения команды с использованием программного интерфейса модуля
//       //   ДополнительныеОтчетыИОбработкиВБезопасномРежимеИнтерфейс.
//       //   Функции, добавляющие этапы сценария:
//       //       ДобавитьМетодКонфигурации() добавляет в сценарий вызов процедуры или функции конфигурации.
//       //         Функция возвращает этап сценария, который затем можно использовать в функция по заполнению параметров.
//       //       ДобавитьМетодОбработки() добавляет в сценарий вызов процедуры или функции объекта дополнительной обработки.
//       //         Функция возвращает этап сценария, который затем можно использовать в функция по заполнению параметров.
//       //   Процедуры, регистрирующие параметры, которые будут переданы в процедуру или функцию, обрабатывающую этап:
//       //       ДобавитьКлючСессии() добавляет в массив параметров текущий ключ сессии расширения безопасного режима.
//       //       ДобавитьЗначение() добавляет в массив параметров фиксированное значение произвольного типа.
//       //       ДобавитьСохраняемоеЗначение() добавляет в массив параметров сохраняемое значение.
//       //       ДобавитьКоллекциюСохраняемыхЗначений() добавляет в массив параметров коллекцию сохраняемых значений.
//       //       ДобавитьПараметрВыполненияКоманды() добавляет в массив параметров элемент структуры ПараметрыВыполненияКоманды.
//       //       ДобавитьОбъектыНазначения() добавляет в массив параметров массив объектов назначения
//       //         (актуально только для назначаемых дополнительных обработок).
//       //   Подробнее см. в документации к подсистеме, раздел "Расширение безопасного режима".
//       //
//       // Параметры:
//       //   ИдентификаторКоманды - Строка - Имя команды, определенное в функции СведенияОВнешнейОбработке().
//       //   ПараметрыВыполнения  - Структура - Контекст выполнения команды.
//       //       * ДополнительнаяОбработкаСсылка - СправочникСсылка.ДополнительныеОтчетыИОбработки - Ссылка этого объекта.
//       //           Может использоваться для чтения параметров обработки.
//       //           Пример см. в комментарии к функции ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыОткрытиеФормы().
//       //
//       // Возвращаемое значение:
//       //   ТаблицаЗначений - Подробнее см. ДополнительныеОтчетыИОбработкиВБезопасномРежимеИнтерфейс.НовыйСценарий().
//       //
//       Функция СформироватьСценарий(ИдентификаторКоманды, ПараметрыВыполнения) Экспорт
//       	Сценарий = ДополнительныеОтчетыИОбработкиВБезопасномРежимеИнтерфейс.НовыйСценарий();
//       	// Формирование сценария.
//       	Возврат Сценарий;
//       КонецФункции
//
// Возвращаемое значение:
//   Строка - имя типа команд по сценарному выполнению в безопасном режиме.
//
Функция ТипКомандыСценарийВБезопасномРежиме() Экспорт
	
	Возврат "СценарийВБезопасномРежиме"; // Внутренний идентификатор.
	
КонецФункции

// Возвращает имя типа команд по загрузке данных из файла. Данные команды доступны
//   только в глобальных обработках (Вид = "ДополнительнаяОбработка")
//   при наличии в конфигурации подсистемы "ЗагрузкаДанныхИзФайла".
//   Для выполнения команд такого типа в модуле объекта следует определить экспортные процедуры по шаблону:
//       // Определяет параметры загрузки данных из файла.
//       //
//       // Параметры:
//       //   ИдентификаторКоманды - Строка - Имя команды, определенное в функции СведенияОВнешнейОбработке().
//       //   ПараметрыЗагрузки - Структура - Настройки загрузки данных:
//       //       * ИмяМакетаСШаблоном - Строка - Имя макета с шаблоном загружаемых данных.
//       //           По умолчанию используется макет "ЗагрузкаИзФайла".
//       //       * ОбязательныеКолонкиМакета - Массив - Список имен колонок обязательных для заполнения.
//       //
//       Процедура ОпределитьПараметрыЗагрузкиДанныхИзФайла(ИдентификаторКоманды, ПараметрыЗагрузки) Экспорт
//       	// Переопределение настроек загрузки данных из файла.
//       КонецПроцедуры
//       
//       // Сопоставляет загружаемые данные с данными в информационной базе.
//       //
//       // Параметры:
//       //   ИдентификаторКоманды - Строка - Имя команды, определенное в функции СведенияОВнешнейОбработке().
//       //   ЗагружаемыеДанные - ТаблицаЗначений - Описание загружаемых данных:
//       //       * СопоставленныйОбъект - СправочникСсылка.Ссылка - Ссылка на сопоставленный объект.
//       //           Заполняется внутри этой процедуры.
//       //       * <другие колонки> - Строка - Данные, загруженные из файла.
//       //           Состав колонок соответствует макету "ЗагрузкаИзФайла".
//       //
//       Процедура СопоставитьЗагружаемыеДанныеИзФайла(ИдентификаторКоманды, ЗагружаемыеДанные) Экспорт
//       	// Реализация логики поиска данных в программе.
//       КонецПроцедуры
//       
//       // Загружает сопоставленные данные в базу.
//       //
//       // Параметры:
//       //   ИдентификаторКоманды - Строка - Имя команды, определенное в функции СведенияОВнешнейОбработке().
//       //   ЗагружаемыеДанные - ТаблицаЗначений - Описание загружаемых данных:
//       //       * СопоставленныйОбъект - СправочникСсылка - Ссылка на сопоставленный объект.
//       //       * РезультатСопоставленияСтроки - Строка - Статус загрузки. Возможны варианты: Создан, Обновлен, Пропущен.
//       //       * ОписаниеОшибки   - Строка - Расшифровка ошибки загрузки данных.
//       //       * Идентификатор    - Число  - Уникальный номер строки.
//       //       * <другие колонки> - Строка - Данные, загруженные из файла.
//       //           Состав колонок соответствует макету "ЗагрузкаИзФайла".
//       //   ПараметрыЗагрузки - Структура - Параметры с пользовательскими установками загрузки данных.
//       //       * СоздаватьНовые        - Булево - Требуется ли создавать новые элементы справочника.
//       //       * ОбновлятьСуществующие - Булево - Требуется ли обновлять элементы справочника.
//       //   Отказ - Булево - Признак отмены загрузки.
//       //
//       Процедура ЗагрузитьИзФайла(ИдентификаторКоманды, ЗагружаемыеДанные, ПараметрыЗагрузки, Отказ) Экспорт
//       	// Реализация логики загрузки данных в программу.
//       КонецПроцедуры
//
// Возвращаемое значение:
//   Строка - имя типа команд по загрузке данных из файла.
//
Функция ТипКомандыЗагрузкаДанныхИзФайла() Экспорт
	
	Возврат "ЗагрузкаДанныхИзФайла"; // Внутренний идентификатор.
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Имена типов форм. Используются при настройке назначаемых объектов.

// Идентификатор формы списка.
//
// Возвращаемое значение:
//   Строка - Идентификатор форм списков.
//
Функция ТипФормыСписка() Экспорт
	
	Возврат "ФормаСписка"; // Внутренний идентификатор.
	
КонецФункции

// Идентификатор формы объекта.
//
// Возвращаемое значение:
//   Строка - Идентификатор форм объектов.
//
Функция ТипФормыОбъекта() Экспорт
	
	Возврат "ФормаОбъекта"; // Внутренний идентификатор.
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Другие процедуры и функции.

// Фильтр для диалогов выбора или сохранения дополнительных отчетов и обработок.
//
// Возвращаемое значение:
//   Строка - Фильтр для диалогов выбора или сохранения дополнительных отчетов и обработок.
//
Функция ФильтрДиалоговВыбораИСохранения() Экспорт
	
	Фильтр = НСтр("ru = 'Внешние отчеты и обработки (*.%1, *.%2)|*.%1;*.%2|Внешние отчеты (*.%1)|*.%1|Внешние обработки (*.%2)|*.%2'");
	Фильтр = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Фильтр, "erf", "epf");
	Возврат Фильтр;
	
КонецФункции

// Идентификатор, который используется для рабочего стола.
//
// Возвращаемое значение:
//   Строка - Идентификатор, который используется для рабочего стола.
//
Функция ИдентификаторРабочегоСтола() Экспорт
	
	Возврат "РабочийСтол"; // Внутренний идентификатор.
	
КонецФункции

// Формирует наименование подсистемы в требуемом формате локализации.
//
// Параметры:
//   ДляПользователя - Булево - Код локализации.
//       Истина - Использовать основной язык текущего сеанса. Используется для вывода сообщений пользователю.
//       Ложь - Использовать основной язык конфигурации. Используется для записи сообщений в журнал регистрации.
//
// Возвращаемое значение:
//   Строка - Представление подсистемы.
//
Функция НаименованиеПодсистемы(ДляПользователя) Экспорт
	КодЯзыка = ?(ДляПользователя, "", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	Возврат НСтр("ru = 'Дополнительные отчеты и обработки'", КодЯзыка);
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Определяет, задано ли расписание регламентного задания.
//
// Параметры:
//   Расписание - РасписаниеРегламентногоЗадания - расписание регламентного задания.
//
// Возвращаемое значение:
//   Булево - Истина, если расписание регламентного задания задано.
//
Функция РасписаниеЗадано(Расписание) Экспорт
	
	Возврат Расписание = Неопределено
		Или Строка(Расписание) <> Строка(Новый РасписаниеРегламентногоЗадания);
	
КонецФункции

#КонецОбласти
