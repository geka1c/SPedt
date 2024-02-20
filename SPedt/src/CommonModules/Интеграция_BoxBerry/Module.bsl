#Область ПрограммныйИнтерфейс
Функция РассчитатьСтоимость(Параметры) Экспорт
	Протокол					= Интеграция_ТранспортныеКомпании_Общий.ПолучитьСтруктуруПротокола();
	Протокол.ОтправленныеДанные = Интеграция_ТранспортныеКомпании_Общий.ПолучитьОтправляемыеДанные(Параметры);
	
	//Проверяем Ограничения ПВЗ
	Если Параметры.Тип<>"boxberryCourier" Тогда
		ОписаниеТочки		= ПолучитьОписаниеТочки(Параметры.КодПВЗ);
		Если ОписаниеТочки <> неопределено Тогда
			ОграничениеВеса 	= ОписаниеТочки.LoadLimit; // Ограничение веса, кг,
			ОграничениеОбъема 	= ОписаниеТочки.VolumeLimit; // Ограничение объема	 м^3.
			Объем				= Параметры.Высота * Параметры.Ширина * Параметры.Длина/1000000;
			ТекстОшибки="";
			Если ОграничениеВеса 	< Параметры.Вес/1000 Тогда
				ТекстОшибки="На данной точке ограничение по весу "+ОграничениеВеса+"кг." +Символы.ПС
			КонецЕсли;	
			Если ОграничениеОбъема	< Объем Тогда
				ТекстОшибки=ТекстОшибки+Символы.ПС+"На данной точке ограничение по объему "+ОграничениеОбъема+"м^3."
			КонецЕсли;	
			Если ТекстОшибки<>"" Тогда
				Протокол.ОтправленныеДанные  = "Запрашиваем ограничения ПВЗ";		
				Протокол.Результат	 		=	"error";
				Протокол.ТекстОшибки 		= ТекстОшибки;
				Протокол.РасчетКалькулятора = ТекстОшибки;
				Протокол.ДатаОкончания = ТекущаяДата();
				Возврат	Протокол; 
			КонецЕсли;
		КонецЕсли;	
	КонецЕсли;
	Структура_Стоимости		= 					  ПолучитьСтоимостьДоставки(Параметры.Вес,
																			Параметры.КодПС,
																			Параметры.КодПВЗ,
																			Параметры.ОбъявленнаяСтоимость,0,0,
																			Параметры.Высота,
																			Параметры.Ширина,
																			Параметры.Длина,
																			Параметры.ИндексПолучателя);
	Протокол.РасчетКалькулятора		= "итоговая цена, например: "+Структура_Стоимости.price+ " руб."+Символы.ПС+
			"базовая цена отправки: "	+ Структура_Стоимости.price_base+ " "+Символы.ПС+
			"стоимость услуг: "			+ Структура_Стоимости.price_service+ " "+Символы.ПС+
			"срок доставки : "			+ Структура_Стоимости.delivery_period;
	Протокол.ТарифТК					= Структура_Стоимости.price;
	Протокол.СрокДоставки 		= Строка(Структура_Стоимости.delivery_period) +" дн.";
	Протокол.ПолученныеДанные    = Протокол.РасчетКалькулятора;
	Протокол.Результат			= "ok";
	Протокол.ДатаОкончания = ТекущаяДата();
	Возврат	Протокол; 
КОнецФункции	

// Возвращает данные классификатора по почтовому индексу.
//
// Параметры:
//     Параметры - Структура - Описание настроек поиска. Поля:
//         * КодПС 		- Строка - Код пункта сдачи заказа.
//         * КодПВЗ 	- Строка - Код пункта Выдачи заказа.
//         * ФИО 		- Строка - ФИО получателя.
//
// Возвращаемое значение:
//     Структура -  Протокол создания заказа:
//       * Отказ                        - Булево - Поставщик не доступен.
//       * ПодробноеПредставлениеОшибки - Строка - Описание ошибки, если поставщик недоступен. Неопределено, если Отказ
//                                                 = Ложь.
//       * КраткоеПредставлениеОшибки   - Строка - Описание ошибки, если поставщик недоступен. Неопределено, если Отказ
//                                                 = Ложь.
//       * ОбщаяЧастьПредставления      - Строка - Общая часть представлений адреса.
//       * Данные                       - ТаблицаЗначений - Содержит данные для выбора. Колонки:
//             ** Неактуален    - Булево - Флаг неактуальности строки данных.
//             ** Идентификатор - УникальныйИдентификатор - Код классификатора для поиска вариантов по индексу.
//             ** Представление - Строка - Представление варианта.
//
Функция СозданиеЗаказаНаДоставку(Параметры) Экспорт
	Протокол					= Интеграция_ТранспортныеКомпании_Общий.ПолучитьСтруктуруПротокола(Перечисления.ВидыОбменовСДЭК.СозданиеЗаказаНаДоставку);
	Протокол.ОтправленныеДанные	= Интеграция_ТранспортныеКомпании_Общий.ПолучитьОтправляемыеДанные(Параметры);
	
	Прокси 	= ПолучитьПроксиЛК();
	
	токен=Константы.ТокенBoxBerry.Получить();
	
	// Пункты Приема Сдачи
	WSП_Shop 		= ПолучитьЭлементТипа(Прокси, "ParselCreateShopData");
	WSП_Shop.name 	= Параметры.КодПВЗ;                				//Код ПВЗ, в котором получатель будет забирать ЗП. Заполняется для самовывоза, для КД – оставить пустым.
	WSП_Shop.name1 	= Параметры.КодПС;       						//Код пункта поступления ЗП (код ПВЗ, в который ИМ сдаёт посылки для доставки). Заполняется всегда, не зависимо от вида доставки. Для ИМ, сдающих отправления на ЦСУ Москва заполняется значением 010
	
	WSП_customer 		= ПолучитьЭлементТипа(Прокси, "ParselCreateCustomerData");
	WSП_customer.fio 	= Параметры.ФИО;                //ФИО получателя ЗП. Возможные варианты заполнения: «Фамилия Имя Отчество» или «Фамилия Имя» (разделитель – пробел).
	WSП_customer.phone 	= Параметры.Телефон;            //Номер мобильного телефона получателя.
	WSП_customer.email 	= Параметры.email;
	
	WSП_weights = ПолучитьЭлементТипа(Прокси, "ParselCreateWeightsData");
	WSП_weights.weight = Параметры.Вес;
	
	
	WSП 							= ПолучитьЭлементТипа(Прокси,"ParselCreateQuery"); 
	WSП.token 						= токен;
	WSП.order_id 					= Параметры.НомерЗаказа;
	WSП.price 						= Параметры.ОбъявленнаяСтоимость;         //Общая (объявленная) стоимость ЗП, руб
	WSП.payment_sum 				= Параметры.ИтогоСтоимость;               //Сумма к оплате (сумма, которую необходимо взять с получателя), руб. Рассчитывается как сумма стоимости товарных вложений и стоимости доставки. Стоимость товарных вложений = сумма (<price> x <quantity>) по всем <item>. Стоимость доставки = <delivery_sum> Для полностью предоплаченного заказа указывать 0
	WSП.delivery_sum 				= Параметры.ТарифТК;          			  //Стоимость доставки, которую ИМ объявил получателю, руб.
	WSП.shop 						= WSП_Shop;
	WSП.customer 					= WSП_customer;
	WSП.weights 					= WSП_weights;
	
	Для Каждого элем из Параметры.СоставЗаказа Цикл
		WSП_item 			= ПолучитьЭлементТипа(Прокси, "ParselCreateItemsData");			
		WSП_item.id			= элем.НомерСтроки;
		WSП_item.name		= элем.Покупка.Наименование;
		WSП_item.nds		=0;
		WSП_item.price		=0;
		WSП_item.quantity	= элем.Количество;
		WSП.items.Добавить(WSП_item);
	КонецЦикла;	
	
	//Определяем тип доставки
	//Вид доставки. Возможные значения: 1 – самовывоз (доставка до ПВЗ), 2 – КД (экспресс-доставка до получателя)
	Если Параметры.Тип="boxberryCourier" Тогда
		WSП_Kurdost = ПолучитьЭлементТипа(Прокси,"ParselCreateKurdostData"); 
		WSП_Kurdost.index   	= Параметры.Индекс;
		WSП_Kurdost.citi    	= Параметры.Город;
		WSП_Kurdost.addressp	= Параметры.Адрес;
		
		WSП.vid 					= "2";
		WSП.kurdost					= WSП_Kurdost;
	Иначе	
		WSП.vid 					= "1";                   
	КонецЕсли;
	
	Попытка
		РезультатРасчета = Прокси.Прокси.ParselCreate(WSП);
		
		Протокол.Результат	 		= "ok";	
		Протокол.ТрекНомер 			= РезультатРасчета.track;  
		Протокол.ПолученныеДанные 	= "label: " + СокрЛП(РезультатРасчета.label) + Символы.ПС
										 + "track: " + СокрЛП(РезультатРасчета.track);
		
	Исключение
		Протокол.Результат	 			= "error";
		Протокол.ПолученныеДанные 		= ОписаниеОшибки();
		Протокол.ТекстОшибки     		= Протокол.ПолученныеДанные;
		
	КонецПопытки;
	Протокол.ДатаОкончания		= ТекущаяДата();
	Возврат Протокол;
КонецФункции

#КонецОбласти 





#Область ПубличныйАПИ
//Позволяет получить список городов, в которых есть пункты выдачи заказов Boxberry
Функция ПолучитьСписокГородов() Экспорт
    Прокси = ПолучитьПроксиПаблик().Прокси;
	токен=Константы.ТокенBoxBerry.Получить();
	ТипWSПараметра = Прокси.ФабрикаXDTO.Пакеты.Получить(ПолучитьПроксиПаблик().Адрес).Получить("ListCitiesQuery");
	WSПараметр=Прокси.ФабрикаXDTO.Создать(ТипWSПараметра);
	WSПараметр.token=токен;
	СписокГородов=Прокси.ListCities(WSПараметр);
    
    Возврат СписокГородов;
КонецФункции

//Позволяет получить информацию о всех точках выдачи заказов. При использовании 
//дополнительного параметра ("code" код города в boxberry, можно получить методом ListCities) 
//позволяет выбрать ПВЗ только в заданном городе.
//По умолчанию возвращается список точек с возможностью оплаты при получении заказа
//(параметр 'OnlyPrepaidOrders'=No). Не возвращает отделения, работающие только с предоплаченными 
//посылками. Если вам необходимо увидеть точки, работающие с любым типом посылок, передайте 
//параметр "prepaid" равный 1
Функция ПолучитьСписокТочек(КодГорода=Неопределено,Предоплата=Неопределено) Экспорт
	Прокси = ПолучитьПроксиПаблик().Прокси;
	токен=Константы.ТокенBoxBerry.Получить();	
	ТипWSПараметра = Прокси.ФабрикаXDTO.Пакеты.Получить(ПолучитьПроксиПаблик().Адрес).Получить("ListPointsQuery");
	WSПараметр=Прокси.ФабрикаXDTO.Создать(ТипWSПараметра);
	WSПараметр.token=токен;
	Если ЗначениеЗаполнено(КодГорода)  Тогда WSПараметр.CityCode = КодГорода; КонецЕсли;
	Если ЗначениеЗаполнено(Предоплата) Тогда WSПараметр.prepaid = Предоплата; КонецЕсли;
	СписокТочек=Прокси.ListPoints(WSПараметр);
    
    Возврат СписокТочек;
КонецФункции

//позволяет получить всю информацию по пункту выдачи, включая фотографии.
Функция ПолучитьОписаниеТочки(КодТочки,получатьФото=ложь) 
	Прокси 			= ПолучитьПроксиПаблик().Прокси;
	токен			= Константы.ТокенBoxBerry.Получить();	
	ТипWSПараметра 	= Прокси.ФабрикаXDTO.Пакеты.Получить(ПолучитьПроксиПаблик().Адрес).Получить("PointsDescriptionQuery");
	WSПараметр		= Прокси.ФабрикаXDTO.Создать(ТипWSПараметра);
	WSПараметр.token=токен;
	WSПараметр.code =КодТочки;
	WSПараметр.photo =истина;
	Попытка
		ОписаниеТочки=Прокси.PointsDescription(WSПараметр);
		Возврат ОписаниеТочки;	
	
	Исключение
		Возврат неопределено;
	КонецПопытки;
	
КонецФункции
	
//Позволяет получить список почтовых индексов, для которых возможна курьерская 
//доставка	
Функция ПолучитьСписокИндексов() 
	Прокси = ПолучитьПроксиПаблик().Прокси;
	токен=Константы.ТокенBoxBerry.Получить();	
	ТипWSПараметра = Прокси.ФабрикаXDTO.Пакеты.Получить(ПолучитьПроксиПаблик().Адрес).Получить("ListZipsQuery");
	WSПараметр=Прокси.ФабрикаXDTO.Создать(ТипWSПараметра);
	WSПараметр.token=токен;
	СписокИндексов=Прокси.ListZips(WSПараметр);
    
    Возврат СписокИндексов;
КонецФункции

//Процедура Позволяет получить стоимость доставки заказа до ПВЗ с учётом стоимости постоянных 
//услуг, предусмотренных Вашим договором, возможен расчет с учетом курьерской доставки. 
//Возвращает базовую стоимость, стоимость услуг (оповещение, выдача, страховой сбор, 
//прием платежа, курьерская доставка и т.п.), срок доставки с учетом варианта выдачи (получение 
//на ПВЗ или курьерская доставка). 
//Если указан почтовый индекс, расчет будет производиться для курьерской доставки по 
//заданному индексу (код пункта выдачи игнорируется).
//Параметры:
//WSServis - WS ссылка,
//токен - токен
// weight - вес посылки в граммах,
// targetstart - код пункта приема посылок,
// target - код пункта выдачи заказов,
// Обратите внимание! Следующие поля считаются равными 0 если не заполнены:
// ordersum - cтоимость товаров без учета стоимости доставки,
// deliverysum - заявленная ИМ стоимость доставки,
// paysum - сумма к оплате
// height - высота коробки (см),
// width - ширина коробки (см),
// depth - глубина коробки (см),
// zip - индекс города для курьерской доставки
// На выходе будет переменная price содержащая итоговую цену в рублях, а также 
//составляющие этой цены (базовая стоимость и стоимость услуг).
Функция ПолучитьСтоимостьДоставки(weight,targetstart,target,ordersum,deliverysum,paysum,
											height,width,depth,zip) 
	Прокси = ПолучитьПроксиПаблик().Прокси;
	токен=Константы.ТокенBoxBerry.Получить();
	
	price=0;
	price_base=0;
	price_service=0;
	delivery_period=0;
	sucrh = 1;
	
    Прокси.DeliveryCosts(токен,weight,targetstart,target,ordersum,deliverysum,paysum,
											height,width,depth,zip,sucrh,price,price_base,price_service,delivery_period);
	Ответ=Новый Структура;											
	Ответ.Вставить("price",price);
	Ответ.Вставить("price_base",price_base);
	Ответ.Вставить("price_service",price_service);
	Ответ.Вставить("delivery_period",delivery_period);
											
    Возврат Ответ;
КонецФункции



#КонецОбласти


#Область ЛичныйКабинетАПИ


Функция ПечатьАктПередачи(ТрекНомер) Экспорт
	
	Прокси = ПолучитьПроксиЛК().Прокси;
	токен=Константы.ТокенBoxBerry.Получить();
	ТипSendQuery = Прокси.ФабрикаXDTO.Тип("api.boxberry.ru", "ParselSendQuery");
	параметрSendQuery = Прокси.ФабрикаXDTO.Создать(ТипSendQuery);
	параметрSendQuery.token=токен;
	параметрSendQuery.ImIds=ТрекНомер;
	
	ответ=Новый Структура;
	Попытка
		Результат = Прокси.ParselSend(параметрSendQuery);

		ответ.Вставить("Успех",Истина);
		ответ.Вставить("Результат",Результат);
		//Сообщить(СокрЛП(Результат));
	Исключение
		ответ.Вставить("Успех",Ложь);
		ответ.Вставить("Результат",ОписаниеОшибки());
		Сообщить(ОписаниеОшибки());
	КонецПопытки;
	Возврат ответ; 	
	
	
	
КонецФункции


//XXXXXX - код отслеживания заказа
//Позволяет получить ссылку на файл печати этикеток, список штрих-кодов коробок в посылке через запятую (,), список штрих-кодов выгруженных коробок в посылке через запятую (,) . Обязательно наличие параметра (код отслеживания заказа).
//Внимание! сервис работает только с посылками созданными в api.boxberry.de
Функция ПечатьЭтикеток(ТрекНомер) Экспорт
	
	Прокси = ПолучитьПроксиЛК().Прокси;
	токен=Константы.ТокенBoxBerry.Получить();
	
	label      ="";
	box        ="";
	box_upload ="";
	ответ=Новый Структура;
	Попытка
		                          
		label = Прокси.ParselCheck(токен, СтрЗаменить(ТрекНомер,"OMS",""));
		Результат=Новый Структура;
		Результат.Вставить("label",label);
		Результат.Вставить("box",box);
		Результат.Вставить("box_upload",box_upload);
		
		ответ.Вставить("Успех",Истина);
		ответ.Вставить("Результат",Результат);
		//Сообщить(СокрЛП(Результат));
	Исключение
		ответ.Вставить("Успех",Ложь);
		ответ.Вставить("Результат",ОписаниеОшибки());
		Сообщить(ОписаниеОшибки());
	КонецПопытки;
	Возврат ответ; 
КонецФункции



Функция СформироватьЗаказ(ДокОтправлениеТранзита)   
	Прокси 		= ПолучитьПроксиЛК().Прокси;
	токен		= Константы.ТокенBoxBerry.Получить();
	
	ТипСписок 					= Прокси.ФабрикаXDTO.Тип("api.boxberry.ru", 	"ParselCreateQuery");
	ТипShop 					= Прокси.ФабрикаXDTO.Тип("api.boxberry.ru", 	"ParselCreateShopData");
	ТипCustomer 				= Прокси.ФабрикаXDTO.Тип("api.boxberry.ru", 	"ParselCreateCustomerData");
	ТипWeights 					= Прокси.ФабрикаXDTO.Тип("api.boxberry.ru", 	"ParselCreateWeightsData");
	ТипItems 					= Прокси.ФабрикаXDTO.Тип("api.boxberry.ru", 	"ParselCreateItemsData");
	ТипParselCreateKurdostData 	= Прокси.ФабрикаXDTO.Тип("api.boxberry.ru", 	"ParselCreateKurdostData");
	
	
	// Заполняем параметр:
	WSПараметрСписок 				= Прокси.ФабрикаXDTO.Создать(ТипСписок);
	
	WSПараметрСписок.token 			= токен;
	WSПараметрСписок.order_id 		= ДокОтправлениеТранзита.Номер;
	//WSПараметрСписок.PalletNumber = "Номер палеты";
	//WSПараметрСписок.barcode = "баркод";                           //Внимание. Если вы передаёте параметр barcode (штрих-код заказа), вам недоступна печать нашей стандартной этикетки.
	WSПараметрСписок.price 			= ДокОтправлениеТранзита.ОбъявленнаяСтоимость;              //Общая (объявленная) стоимость ЗП, руб
	WSПараметрСписок.payment_sum 	= ДокОтправлениеТранзита.ИтогоСтоимость;               //Сумма к оплате (сумма, которую необходимо взять с получателя), руб. Рассчитывается как сумма стоимости товарных вложений и стоимости доставки. Стоимость товарных вложений = сумма (<price> x <quantity>) по всем <item>. Стоимость доставки = <delivery_sum> Для полностью предоплаченного заказа указывать 0
	
	//Если ДокОтправлениеТранзита.Коробка.МетодОплаты =Перечисления.МетодыОплаты.cod Тогда
	WSПараметрСписок.delivery_sum = ДокОтправлениеТранзита.ТарифТК;          //Стоимость доставки, которую ИМ объявил получателю, руб.
	//Иначе	
	//	WSПараметрСписок.delivery_sum=0;
	//КонецЕсли;	
	Если ДокОтправлениеТранзита.Тип="boxberryCourier" Тогда
		WSПараметрСписок.vid 					= "2";
		ОбъектParselCreateKurdostData 			= Прокси.ФабрикаXDTO.Создать(ТипParselCreateKurdostData);
		ОбъектParselCreateKurdostData.index   	= ДокОтправлениеТранзита.Индекс;
		ОбъектParselCreateKurdostData.citi    	= ДокОтправлениеТранзита.Город;
		ОбъектParselCreateKurdostData.addressp	= ДокОтправлениеТранзита.Адрес;
		WSПараметрСписок.kurdost				= ОбъектParselCreateKurdostData;
	Иначе	
		WSПараметрСписок.vid = "1";                   //Вид доставки. Возможные значения: 1 – самовывоз (доставка до ПВЗ), 2 – КД (экспресс-доставка до получателя)
	КонецЕсли;
	СписокShop = Прокси.ФабрикаXDTO.Создать(ТипShop);
	
	СписокShop.name = ДокОтправлениеТранзита.КодПВЗ;                //Код ПВЗ, в котором получатель будет забирать ЗП. Заполняется для самовывоза, для КД – оставить пустым.
	СписокShop.name1 =ДокОтправлениеТранзита.ПунктПриема.Код;       //Код пункта поступления ЗП (код ПВЗ, в который ИМ сдаёт посылки для доставки). Заполняется всегда, не зависимо от вида доставки. Для ИМ, сдающих отправления на ЦСУ Москва заполняется значением 010
	
	WSПараметрСписок.shop = СписокShop;
	
	СписокCustomer = Прокси.ФабрикаXDTO.Создать(ТипCustomer);
	
	СписокCustomer.fio = ДокОтправлениеТранзита.ФИО;                //ФИО получателя ЗП. Возможные варианты заполнения: «Фамилия Имя Отчество» или «Фамилия Имя» (разделитель – пробел).
																	//Внимание, для полностью предоплаченных заказов необходимо указывать Фамилию, Имя и Отчество получателя, т. к. при выдаче на ПВЗ проверяются паспортные данные.
	СписокCustomer.phone = ДокОтправлениеТранзита.Телефон;          //Номер мобильного телефона получателя.
																	//Внимание, если вы используете наше СМС-и/или голосовое оповещение, номер мобильного телефона необходимо передавать в формате 9ХХХХХХХХХ (10 цифр, начиная с девятки).

	//СписокCustomer.phone2 = "Доп. номер телефона";
	СписокCustomer.email = ДокОтправлениеТранзита.email;
	
	//name, address, inn, kpp, r_s, bank, kor_s, bik
	//Наименование юрлица-получателя. 
	//Внимание, данные поля обязательны для заполнения, если заказчиком и плательщиком по ЗП является юрлицо. При этом в поле <fio> указываются данные представителя юрлица, который будет получать ЗП. Для физлиц эти поля не заполняется.	
	//СписокCustomer.name = "Наименование организации";
	//СписокCustomer.address = "Адрес";
	//СписокCustomer.inn = "ИНН";
	//СписокCustomer.kpp = "КПП";
	//СписокCustomer.r_s = "Расчетный счет";
	//СписокCustomer.bank = "Наименование банка";
	//СписокCustomer.kor_s = "Кор. счет";
	//СписокCustomer.bik = "БИК";
	
	WSПараметрСписок.customer = СписокCustomer;
	Выборка=ДокОтправлениеТранзита.Заказы.Выбрать();
	
	РаскидаемПоТоварам=ДокОтправлениеТранзита.ИтогоСтоимость-ДокОтправлениеТранзита.ТарифТК;
	РаскидаемПоТоварам=?(РаскидаемПоТоварам<0,0,РаскидаемПоТоварам);
	ценаОдного=РаскидаемПоТоварам/Выборка.Количество();
	Пока Выборка.Следующий() Цикл
		СписокItems=Прокси.ФабрикаXDTO.Создать(ТипItems);
		СписокItems.id= Выборка.НомерСтроки;
		СписокItems.name=Выборка.Покупка.Наименование;
		СписокItems.nds=0;
		ЦенаПозиции=0;//ценаОдного/Выборка.Количество;
		СписокItems.price=ЦенаПозиции;
		СписокItems.quantity=Выборка.Количество;
		WSПараметрСписок.items.Добавить(СписокItems);
	КонецЦикла;
	
	
	СписокWeights = Прокси.ФабрикаXDTO.Создать(ТипWeights);
	
	СписокWeights.weight = ДокОтправлениеТранзита.Вес;
	СписокWeights.weight2 = "0";
	СписокWeights.weight3 = "0";
	СписокWeights.weight4 = "0";
	СписокWeights.weight5 = "0";
	
	WSПараметрСписок.weights = СписокWeights;
	ответ=Новый Структура;
	// Обращаемся:
	Попытка
		Результат = Прокси.ParselCreate(WSПараметрСписок);

		ответ.Вставить("Успех",Истина);
		ответ.Вставить("Результат",Результат);
		Сообщить("label: " + СокрЛП(Результат.label) + Символы.ПС + "track: " + СокрЛП(Результат.track));
	Исключение
		ответ.Вставить("Успех",Ложь);
		ответ.Вставить("Результат",ОписаниеОшибки());
		Сообщить(ОписаниеОшибки());
	КонецПопытки;
	Возврат ответ; 
КонецФункции


Функция УдалитьЗаказ(ТрекНомер) Экспорт
	Прокси = ПолучитьПроксиЛК().Прокси;
	токен=Константы.ТокенBoxBerry.Получить();

	ответ=Новый Структура;
	Попытка
		Результат = Прокси.ParselDel(токен, ТрекНомер);

		ответ.Вставить("Успех",Истина);
		ответ.Вставить("Результат",Результат);
		//Сообщить(СокрЛП(Результат));
	Исключение
		ответ.Вставить("Успех",Ложь);
		ответ.Вставить("Результат",ОписаниеОшибки());
		Сообщить(ОписаниеОшибки());
	КонецПопытки;
	Возврат ответ; 	
КонецФункции	


#КонецОбласти



#Область ВспомогательныеФункции
Функция ПолучитьПроксиПаблик()
	WSServis=WSСсылки.WSBoxBerry;
	ОписаниеСервиса = WSServis.ПолучитьWSОпределения().Сервисы[0];
    Адрес        	= ОписаниеСервиса.URIПространстваИмен;
    ИмяСервиса     	= ОписаниеСервиса.Имя;                            
    ИмяПорта     	= ОписаниеСервиса.ТочкиПодключения[0].Имя;
    Прокси 			= WSServis.СоздатьWSПрокси(Адрес,ИмяСервиса,ИмяПорта,,,);
	
	Возврат новый Структура("Прокси,Адрес",Прокси,Адрес);
КонецФункции	

Функция ПолучитьПроксиЛК_олд()
	WSServis=WSСсылки.WSBoxBerryLK;
	ОписаниеСервиса = WSServis.ПолучитьWSОпределения().Сервисы[0];
    Адрес        	= ОписаниеСервиса.URIПространстваИмен;
    ИмяСервиса     	= ОписаниеСервиса.Имя;                            
    ИмяПорта     	= ОписаниеСервиса.ТочкиПодключения[0].Имя;
    Прокси 			= WSServis.СоздатьWSПрокси(Адрес,ИмяСервиса,ИмяПорта,,,);
	Возврат новый Структура("Прокси,Адрес",Прокси,Адрес);
КонецФункции	


//hhttp://api.boxberry.de/__soap/1c_lc.php?wsdl
Функция ПолучитьПроксиЛК()
    URL = "https://api.boxberry.ru/__soap/1c_lc.php?wsdl";
    WSОпределения 	= Новый WSОпределения(URL);	
	Namespace 		= WSОпределения.Сервисы[0].URIПространстваИмен;
	WSПрокси 		= Новый WSПрокси(WSОпределения, Namespace, WSОпределения.Сервисы[0].Имя, WSОпределения.Сервисы[0].ТочкиПодключения[0].Имя);
	Возврат новый Структура("Прокси,Namespace,Фабрика",WSПрокси, Namespace, WSПрокси.ФабрикаXDTO);
КонецФункции	


Функция ПолучитьЭлементТипа(Прокси, ИмяТипа)
	Фабрика		= Прокси.Фабрика;
	Namespace  	= Прокси.Namespace;
	Возврат Фабрика.Создать(Фабрика.Тип(Namespace,ИмяТипа));
КонецФункции	



#КонецОбласти