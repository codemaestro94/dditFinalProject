package kr.or.ddit.service.owner.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import kr.or.ddit.mapper.owner.FrcsBillMapper;
import kr.or.ddit.mapper.owner.FrcsOperationMapper;
import kr.or.ddit.mapper.owner.FrcsTotalProfitMapper;
import kr.or.ddit.service.owner.IFrcsOperationProfitService;
import kr.or.ddit.vo.head.FeeVO;
import kr.or.ddit.vo.owner.FrcsBillVO;
import kr.or.ddit.vo.owner.FrcsDailySalesVO;
import kr.or.ddit.vo.owner.OperationProfitVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class FrcsOperationProfitServiceImpl implements IFrcsOperationProfitService {

	@Inject
	private FrcsOperationMapper mapper;
	
	@Inject
	private FrcsTotalProfitMapper totalMapper;
	
	@Inject
	private FrcsBillMapper billMapper;

	// 순이익 분석 (한달)
	@Override
	public OperationProfitVO getOneOperation(String frcsId, Date thisMonth) {
		
		OperationProfitVO operationVO = new OperationProfitVO();
		
		// 매출액
		int sales = totalMapper.getTotalSales(frcsId, thisMonth);
		
		// 청구금
		FrcsBillVO billVO = new FrcsBillVO(); // 가맹비 상세
		FeeVO feeVO = new FeeVO(); // 본사 가맹비 총괄

		int frcsRowal = billMapper.getfrcsRowal(frcsId,thisMonth);	// 로얄티
		int orderAmt = billMapper.getorderAmt(frcsId,thisMonth);	// 제품구입비
		int tradAdd = billMapper.gettradAdd(frcsId,thisMonth);		// 트레이딩 추가결제비
		int tradRedct = billMapper.gettradRedct(frcsId,thisMonth);	// 트레이딩 삭감비
		int frcsAmt = billVO.getFrcsAmt();
		
		// 총 청구금액
		int headCharge = 0;
		
		// 청구시작일자 구하기
		Calendar cal1 = Calendar.getInstance();
		cal1.setTime(thisMonth);
		cal1.add(cal1.MONTH, 1);	// 월에 1을 더함
		
		// 납부기준일 구하기
		Calendar cal2 = Calendar.getInstance();
		cal2.setTime(thisMonth);
		cal2.add(cal2.MONTH, 1);	// 월에 1을 더함
		cal2.add(cal2.DAY_OF_MONTH, 14);	// 일에 14일을 더함
		
		Calendar now = Calendar.getInstance();	// 오늘 날짜
		
		Date feeDday = cal1.getTime();	// 청구일자(1일)
		Date feeChargedate = cal2.getTime(); // 납부기준일(15일)
		Date nowDate = now.getTime();	// 오늘 날짜
		
		// 총 청구금액
		headCharge = (frcsAmt + frcsRowal + orderAmt+ tradAdd) - tradRedct;	
		
		feeVO.setFeeChargedate(feeChargedate);
		feeVO.setFrcsId(frcsId);

		// 가맹비 총괄 테이블에 데이터가 존재하는지 체크
		int duplicationCheck = billMapper.dupliCheck(feeVO);

		if(duplicationCheck>0) {
			billVO.setSettleAt("Y");	// 데이터가 존재하면 납부를 한거기때문에 납부상태 Y로 변경
			
			Date settleDate = billMapper.getSettleDate(feeVO);
			billVO.setSettleDate(settleDate);
			
			if(settleDate.compareTo(feeDday) >=0 && settleDate.compareTo(feeChargedate) <=0) {
				billVO.setFrcsbillOverdue(0);
			}
			
			// 오늘날짜가 청구일자와 같거나 크면서 납부 기준일보다 크면 이자 발생
			if(settleDate.compareTo(feeDday) >=0 && settleDate.compareTo(feeChargedate) > 0) {

				// 첫 한달은 1% 이자 발생
				int overdue = (int) (headCharge * 0.01);
				
				billVO.setFrcsbillOverdue(overdue);
				
				headCharge = (frcsAmt + frcsRowal + orderAmt+ tradAdd) - tradRedct + overdue;
			}
		}else {
			
			// 오늘날짜가 청구일자와 같거나 크면서 납부 기준일보다 같거나 작으면 이자 발생 x
			if(nowDate.compareTo(feeDday) >=0 && nowDate.compareTo(feeChargedate) <=0) {
				billVO.setFrcsbillOverdue(0);
			}
			
			// 오늘날짜가 청구일자와 같거나 크면서 납부 기준일보다 크면 이자 발생
			if(nowDate.compareTo(feeDday) >=0 && nowDate.compareTo(feeChargedate) > 0) {

				// 첫 한달은 1% 이자 발생
				int overdue = (int) (headCharge * 0.01);
				
				billVO.setFrcsbillOverdue(overdue);
				
				headCharge = (frcsAmt + frcsRowal + orderAmt+ tradAdd) - tradRedct + overdue;
				
			}
		}
		
		// 인건비
		int pay = mapper.getPay(frcsId);
		
		// 공과금 및 월세
		int publicDues = mapper.getSumPublicDues(frcsId, thisMonth);
		
		// 영업이익
		int operationProfit = sales-(headCharge+pay+publicDues);
		
		// 당기 순이익
		double currentIncome = operationProfit- (operationProfit*0.01);
		int currentIncomeInt = (int) currentIncome;
		
		operationVO.setSales(sales);
		operationVO.setHeadCharge(headCharge);
		operationVO.setPublicDues(publicDues);
		operationVO.setOperationProfit(operationProfit);
		operationVO.setCurrentIncome(currentIncomeInt);
		operationVO.setPay(pay);
		
		return operationVO;
	}

	// 순이익 1개월 ajax
	@Override
	public OperationProfitVO getOneTotal(OperationProfitVO operVO) {
		
		String frcsId = operVO.getFrcsId();
		String thisMonthStr = operVO.getThisMonth();
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM");
		Date thisMonth = null;
		
		try {
			thisMonth = sdf.parse(thisMonthStr);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		
		OperationProfitVO operationVO = new OperationProfitVO();
		
		// 매출액
		int sales = totalMapper.getTotalSales(frcsId, thisMonth);
		
		// 청구금
		FrcsBillVO billVO = new FrcsBillVO(); // 가맹비 상세
		FeeVO feeVO = new FeeVO(); // 본사 가맹비 총괄

		int frcsRowal = billMapper.getfrcsRowal(frcsId,thisMonth);	// 로얄티
		int orderAmt = billMapper.getorderAmt(frcsId,thisMonth);	// 제품구입비
		int tradAdd = billMapper.gettradAdd(frcsId,thisMonth);		// 트레이딩 추가결제비
		int tradRedct = billMapper.gettradRedct(frcsId,thisMonth);	// 트레이딩 삭감비
		int frcsAmt = billVO.getFrcsAmt();
		
		// 총 청구금액
		int headCharge = 0;
		
		// 청구시작일자 구하기
		Calendar cal1 = Calendar.getInstance();
		cal1.setTime(thisMonth);
		cal1.add(cal1.MONTH, 1);	// 월에 1을 더함
		
		// 납부기준일 구하기
		Calendar cal2 = Calendar.getInstance();
		cal2.setTime(thisMonth);
		cal2.add(cal2.MONTH, 1);	// 월에 1을 더함
		cal2.add(cal2.DAY_OF_MONTH, 14);	// 일에 14일을 더함
		
		Calendar now = Calendar.getInstance();	// 오늘 날짜
		
		Date feeDday = cal1.getTime();	// 청구일자(1일)
		Date feeChargedate = cal2.getTime(); // 납부기준일(15일)
		Date nowDate = now.getTime();	// 오늘 날짜
		
		// 총 청구금액
		headCharge = (frcsAmt + frcsRowal + orderAmt+ tradAdd) - tradRedct;	
		
		feeVO.setFeeChargedate(feeChargedate);
		feeVO.setFrcsId(frcsId);

		// 가맹비 총괄 테이블에 데이터가 존재하는지 체크
		int duplicationCheck = billMapper.dupliCheck(feeVO);

		if(duplicationCheck>0) {
			billVO.setSettleAt("Y");	// 데이터가 존재하면 납부를 한거기때문에 납부상태 Y로 변경
			
			Date settleDate = billMapper.getSettleDate(feeVO);
			billVO.setSettleDate(settleDate);
			
			if(settleDate.compareTo(feeDday) >=0 && settleDate.compareTo(feeChargedate) <=0) {
				billVO.setFrcsbillOverdue(0);
			}
			
			// 오늘날짜가 청구일자와 같거나 크면서 납부 기준일보다 크면 이자 발생
			if(settleDate.compareTo(feeDday) >=0 && settleDate.compareTo(feeChargedate) > 0) {

				// 첫 한달은 1% 이자 발생
				int overdue = (int) (headCharge * 0.01);
				
				log.info("overdue : " + overdue);
				// 오늘날짜가 납부 기준일보다 2달 이상 지났으면 3% 이자 발생
				billVO.setFrcsbillOverdue(overdue);
				
				headCharge = (frcsAmt + frcsRowal + orderAmt+ tradAdd) - tradRedct + overdue;
			}
		}else {
			
			// 오늘날짜가 청구일자와 같거나 크면서 납부 기준일보다 같거나 작으면 이자 발생 x
			if(nowDate.compareTo(feeDday) >=0 && nowDate.compareTo(feeChargedate) <=0) {
				billVO.setFrcsbillOverdue(0);
			}
			
			// 오늘날짜가 청구일자와 같거나 크면서 납부 기준일보다 크면 이자 발생
			if(nowDate.compareTo(feeDday) >=0 && nowDate.compareTo(feeChargedate) > 0) {

				// 1% 이자 발생
				int overdue = (int) (headCharge * 0.01);
			
				billVO.setFrcsbillOverdue(overdue);
				
				headCharge = (frcsAmt + frcsRowal + orderAmt+ tradAdd) - tradRedct + overdue;
				
			}
		}
		
		// 인건비
		int pay = mapper.getPay(frcsId);
		
		// 공과금 및 월세
		int publicDues = mapper.getSumPublicDues(frcsId, thisMonth);
		
		// 영업이익
		int operationProfit = sales-(headCharge+publicDues+pay);
		
		// 당기 순이익
		double currentIncome = operationProfit- (operationProfit*0.01);
		int currentIncomeInt = (int) currentIncome;
		
		operationVO.setSales(sales);
		operationVO.setHeadCharge(headCharge);
		operationVO.setPublicDues(publicDues);
		operationVO.setOperationProfit(operationProfit);
		operationVO.setCurrentIncome(currentIncomeInt);
		operationVO.setPay(pay);
		
		return operationVO;
		
	}

	// 순이익 3개월
	@Override
	public OperationProfitVO getThreeTotal(OperationProfitVO operVO) {
		
		String frcsId = operVO.getFrcsId();
		String thisMonthStr = operVO.getThisMonth();
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM");
		Date dateInfo = null;
		
		try {
			dateInfo = sdf.parse(thisMonthStr);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		
		OperationProfitVO operationVO = new OperationProfitVO();
		
		int sales = 0;	// 매출액
		int headCharge = 0;	// 본사 총 청구금액
		int pay = 0;
		int publicDues = 0;	// 공과금 및 월세
		
		// 청구금
		FrcsBillVO billVO = new FrcsBillVO(); // 가맹비 상세
		FeeVO feeVO = new FeeVO(); // 본사 가맹비 총괄

		for(int i=0; i<3; i++) {
			Calendar cal = Calendar.getInstance();
			cal.setTime(dateInfo);
			cal.add(cal.MONTH, -i);	// 월에 -1
			Date thisMonth = cal.getTime();
			
			log.info("thisMonth : " + thisMonth);
		
		// 매출액
		sales += totalMapper.getTotalSales(frcsId, thisMonth);
		int frcsRowalTemp = billMapper.getfrcsRowal(frcsId,thisMonth);	// 로얄티
		int orderAmtTemp = billMapper.getorderAmt(frcsId,thisMonth);	// 제품구입비
		int tradAddTemp = billMapper.gettradAdd(frcsId,thisMonth);		// 트레이딩 추가결제비
		int tradRedctTemp = billMapper.gettradRedct(frcsId,thisMonth);	// 트레이딩 삭감비
		int frcsAmtTemp = billVO.getFrcsAmt();
		
		// 청구시작일자 구하기
		Calendar cal1 = Calendar.getInstance();
		cal1.setTime(thisMonth);
		cal1.add(cal1.MONTH, 1);	// 월에 1을 더함
		
		// 납부기준일 구하기
		Calendar cal2 = Calendar.getInstance();
		cal2.setTime(thisMonth);
		cal2.add(cal2.MONTH, 1);	// 월에 1을 더함
		cal2.add(cal2.DAY_OF_MONTH, 14);	// 일에 14일을 더함
		
		Calendar now = Calendar.getInstance();	// 오늘 날짜
		
		Date feeDday = cal1.getTime();	// 청구일자(1일)
		Date feeChargedate = cal2.getTime(); // 납부기준일(15일)
		Date nowDate = now.getTime();	// 오늘 날짜
		
		log.info("청구일자(1일) : " + feeDday);
		log.info("납부기준일(15일) : " + feeChargedate);
		log.info("오늘 : " + nowDate);
		
		
		// 총 청구금액
		int headChargeTemp = (frcsAmtTemp + frcsRowalTemp + orderAmtTemp+ tradAddTemp) - tradRedctTemp;	
		log.info("headChargeTemp : " + headChargeTemp);

		feeVO.setFeeChargedate(feeChargedate);
		feeVO.setFrcsId(frcsId);

		// 가맹비 총괄 테이블에 데이터가 존재하는지 체크
		int duplicationCheck = billMapper.dupliCheck(feeVO);

		if(duplicationCheck>0) {
			billVO.setSettleAt("Y");	// 데이터가 존재하면 납부를 한거기때문에 납부상태 Y로 변경
			
			Date settleDate = billMapper.getSettleDate(feeVO);
			billVO.setSettleDate(settleDate);
			
			if(settleDate.compareTo(feeDday) >=0 && settleDate.compareTo(feeChargedate) <=0) {
				billVO.setFrcsbillOverdue(0);
				headChargeTemp = (frcsAmtTemp + frcsRowalTemp + orderAmtTemp+ tradAddTemp) - tradRedctTemp;	
				log.info("이자안붙음 : " + headChargeTemp);
			}
			
			// 오늘날짜가 청구일자와 같거나 크면서 납부 기준일보다 크면 이자 발생
			if(settleDate.compareTo(feeDday) >=0 && settleDate.compareTo(feeChargedate) > 0) {

				// 첫 한달은 1% 이자 발생
				int overdue = (int) (headChargeTemp * 0.01);
				log.info("오늘날짜가 청구일자와 같거나 크면서 납부 기준일보다 크면 이자 발생 : " + overdue);
				billVO.setFrcsbillOverdue(overdue);
				
				headChargeTemp = (frcsAmtTemp + frcsRowalTemp + orderAmtTemp+ tradAddTemp) - tradRedctTemp + overdue;
				log.info("이자붙음 : " + headChargeTemp);

			}
		}else {
			
			// 오늘날짜가 청구일자와 같거나 크면서 납부 기준일보다 같거나 작으면 이자 발생 x
			if(nowDate.compareTo(feeDday) >=0 && nowDate.compareTo(feeChargedate) <=0) {
				billVO.setFrcsbillOverdue(0);
				headChargeTemp = (frcsAmtTemp + frcsRowalTemp + orderAmtTemp+ tradAddTemp) - tradRedctTemp;	
				log.info("이자안붙음 : " + headChargeTemp);
			}
			
			// 오늘날짜가 청구일자와 같거나 크면서 납부 기준일보다 크면 이자 발생
			if(nowDate.compareTo(feeDday) >=0 && nowDate.compareTo(feeChargedate) > 0) {

				// 1% 이자 발생
				int overdue = (int) (headChargeTemp * 0.01);
				log.info(" 오늘날짜가 청구일자와 같거나 크면서 납부 기준일보다 크면 이자 발생 else : " + overdue);
				billVO.setFrcsbillOverdue(overdue);
				
				headChargeTemp = (frcsAmtTemp + frcsRowalTemp + orderAmtTemp+ tradAddTemp) - tradRedctTemp + overdue;
				log.info("이자붙음 : " + headChargeTemp);

			}
		}
		
		// 인건비
		pay += mapper.getPay(frcsId);
		
		// 공과금 및 월세
		publicDues += mapper.getSumPublicDues(frcsId, thisMonth);
		
		headCharge += headChargeTemp;
		
		}
		
		operationVO.setSales(sales);
		operationVO.setHeadCharge(headCharge);
		operationVO.setPublicDues(publicDues);
		
		// 영업 이익 (매출액 - 본사청구액+인건비+월세)
		int operationProfitTemp = sales-(headCharge+pay+publicDues);
		double currentIncomeTemp = operationProfitTemp- (operationProfitTemp*0.01);
		int currentIncomeInt = (int) currentIncomeTemp;
		
		operationVO.setOperationProfit(operationProfitTemp);
		operationVO.setCurrentIncome(currentIncomeInt);
		operationVO.setPay(pay);
		
		log.info("operationVO : " + operationVO);
		
		return operationVO;
	}

	// 순이익 6개월
	@Override
	public OperationProfitVO getSixTotal(OperationProfitVO operVO) {
		
		String frcsId = operVO.getFrcsId();
		String thisMonthStr = operVO.getThisMonth();
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM");
		Date dateInfo = null;
		
		try {
			dateInfo = sdf.parse(thisMonthStr);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		
		OperationProfitVO operationVO = new OperationProfitVO();
		
		int sales = 0;	// 매출액
		int headCharge = 0;	// 본사 총 청구금액
		int pay = 0;
		int publicDues = 0;	// 공과금 및 월세
		
		// 청구금
		FrcsBillVO billVO = new FrcsBillVO(); // 가맹비 상세
		FeeVO feeVO = new FeeVO(); // 본사 가맹비 총괄

		for(int i=0; i<6; i++) {
			Calendar cal = Calendar.getInstance();
			cal.setTime(dateInfo);
			cal.add(cal.MONTH, -i);	// 월에 -1
			Date thisMonth = cal.getTime();
			
			log.info("thisMonth : " + thisMonth);
		
		// 매출액
		sales += totalMapper.getTotalSales(frcsId, thisMonth);
		int frcsRowalTemp = billMapper.getfrcsRowal(frcsId,thisMonth);	// 로얄티
		int orderAmtTemp = billMapper.getorderAmt(frcsId,thisMonth);	// 제품구입비
		int tradAddTemp = billMapper.gettradAdd(frcsId,thisMonth);		// 트레이딩 추가결제비
		int tradRedctTemp = billMapper.gettradRedct(frcsId,thisMonth);	// 트레이딩 삭감비
		int frcsAmtTemp = billVO.getFrcsAmt();
		
		// 청구시작일자 구하기
		Calendar cal1 = Calendar.getInstance();
		cal1.setTime(thisMonth);
		cal1.add(cal1.MONTH, 1);	// 월에 1을 더함
		
		// 납부기준일 구하기
		Calendar cal2 = Calendar.getInstance();
		cal2.setTime(thisMonth);
		cal2.add(cal2.MONTH, 1);	// 월에 1을 더함
		cal2.add(cal2.DAY_OF_MONTH, 14);	// 일에 14일을 더함
		
		Calendar now = Calendar.getInstance();	// 오늘 날짜
		
		Date feeDday = cal1.getTime();	// 청구일자(1일)
		Date feeChargedate = cal2.getTime(); // 납부기준일(15일)
		Date nowDate = now.getTime();	// 오늘 날짜
		
		log.info("청구일자(1일) : " + feeDday);
		log.info("납부기준일(15일) : " + feeChargedate);
		log.info("오늘 : " + nowDate);
		
		
		// 총 청구금액
		int headChargeTemp = (frcsAmtTemp + frcsRowalTemp + orderAmtTemp+ tradAddTemp) - tradRedctTemp;	
		log.info("headChargeTemp : " + headChargeTemp);

		feeVO.setFeeChargedate(feeChargedate);
		feeVO.setFrcsId(frcsId);

		// 가맹비 총괄 테이블에 데이터가 존재하는지 체크
		int duplicationCheck = billMapper.dupliCheck(feeVO);

		if(duplicationCheck>0) {
			billVO.setSettleAt("Y");	// 데이터가 존재하면 납부를 한거기때문에 납부상태 Y로 변경
			
			Date settleDate = billMapper.getSettleDate(feeVO);
			billVO.setSettleDate(settleDate);
			
			if(settleDate.compareTo(feeDday) >=0 && settleDate.compareTo(feeChargedate) <=0) {
				billVO.setFrcsbillOverdue(0);
				headChargeTemp = (frcsAmtTemp + frcsRowalTemp + orderAmtTemp+ tradAddTemp) - tradRedctTemp;	
				log.info("이자안붙음 : " + headChargeTemp);
			}
			
			// 오늘날짜가 청구일자와 같거나 크면서 납부 기준일보다 크면 이자 발생
			if(settleDate.compareTo(feeDday) >=0 && settleDate.compareTo(feeChargedate) > 0) {

				// 첫 한달은 1% 이자 발생
				int overdue = (int) (headChargeTemp * 0.01);
				log.info("오늘날짜가 청구일자와 같거나 크면서 납부 기준일보다 크면 이자 발생 : " + overdue);
				billVO.setFrcsbillOverdue(overdue);
				
				headChargeTemp = (frcsAmtTemp + frcsRowalTemp + orderAmtTemp+ tradAddTemp) - tradRedctTemp + overdue;
				log.info("이자붙음 : " + headChargeTemp);

			}
		}else {
			
			// 오늘날짜가 청구일자와 같거나 크면서 납부 기준일보다 같거나 작으면 이자 발생 x
			if(nowDate.compareTo(feeDday) >=0 && nowDate.compareTo(feeChargedate) <=0) {
				billVO.setFrcsbillOverdue(0);
				headChargeTemp = (frcsAmtTemp + frcsRowalTemp + orderAmtTemp+ tradAddTemp) - tradRedctTemp;	
				log.info("이자안붙음 : " + headChargeTemp);
			}
			
			// 오늘날짜가 청구일자와 같거나 크면서 납부 기준일보다 크면 이자 발생
			if(nowDate.compareTo(feeDday) >=0 && nowDate.compareTo(feeChargedate) > 0) {

				// 1% 이자 발생
				int overdue = (int) (headChargeTemp * 0.01);
				log.info(" 오늘날짜가 청구일자와 같거나 크면서 납부 기준일보다 크면 이자 발생 else : " + overdue);
				billVO.setFrcsbillOverdue(overdue);
				
				headChargeTemp = (frcsAmtTemp + frcsRowalTemp + orderAmtTemp+ tradAddTemp) - tradRedctTemp + overdue;
				log.info("이자붙음 : " + headChargeTemp);

			}
		}
		
		// 인건비
		pay += mapper.getPay(frcsId);
		
		// 공과금 및 월세
		publicDues += mapper.getSumPublicDues(frcsId, thisMonth);
		
		headCharge += headChargeTemp;
		
		}
		
		operationVO.setSales(sales);
		operationVO.setHeadCharge(headCharge);
		operationVO.setPublicDues(publicDues);
		
		// 영업 이익 (매출액 - 본사청구액+인건비+월세)
		int operationProfitTemp = sales-(headCharge+pay+publicDues);
		double currentIncomeTemp = operationProfitTemp- (operationProfitTemp*0.01);
		int currentIncomeInt = (int) currentIncomeTemp;
		
		operationVO.setOperationProfit(operationProfitTemp);
		operationVO.setCurrentIncome(currentIncomeInt);
		operationVO.setPay(pay);
		
		log.info("operationVO : " + operationVO);
		
		return operationVO;
	}

	// 순이익 차트 12개월
	@Override
	public List<OperationProfitVO> getOperationProfitChart(String frcsId) {

		List<OperationProfitVO> monthsList = new ArrayList<OperationProfitVO>();
		
		// 현재 날짜 구하기
		LocalDate now = LocalDate.now();
		int year = now.getYear(); 	// 올해
		
		String str = "";
		
		for(int i=1; i<13; i++) {
			
			if(i<10) {
				str = year+"/"+"0"+i+"/01";
			}else {
				str = year+"/"+i+"/01";
			}
			
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
			Date thisMonth = null;
			
			try {
				thisMonth = sdf.parse(str);
			} catch (ParseException e) {
				e.printStackTrace();
			}
			
			OperationProfitVO operationVO = new OperationProfitVO();
			
			// 매출액
			int sales = totalMapper.getTotalSales(frcsId, thisMonth);
			
			// 청구금
			FrcsBillVO billVO = new FrcsBillVO(); // 가맹비 상세
			FeeVO feeVO = new FeeVO(); // 본사 가맹비 총괄

			int frcsRowal = billMapper.getfrcsRowal(frcsId,thisMonth);	// 로얄티
			int orderAmt = billMapper.getorderAmt(frcsId,thisMonth);	// 제품구입비
			int tradAdd = billMapper.gettradAdd(frcsId,thisMonth);		// 트레이딩 추가결제비
			int tradRedct = billMapper.gettradRedct(frcsId,thisMonth);	// 트레이딩 삭감비
			int frcsAmt = billVO.getFrcsAmt();
			
			// 총 청구금액
			int headCharge = 0;
			
			// 청구시작일자 구하기
			Calendar cal1 = Calendar.getInstance();
			cal1.setTime(thisMonth);
			cal1.add(cal1.MONTH, 1);	// 월에 1을 더함
			
			// 납부기준일 구하기
			Calendar cal2 = Calendar.getInstance();
			cal2.setTime(thisMonth);
			cal2.add(cal2.MONTH, 1);	// 월에 1을 더함
			cal2.add(cal2.DAY_OF_MONTH, 14);	// 일에 14일을 더함
			
			Calendar now1 = Calendar.getInstance();	// 오늘 날짜
			
			Date feeDday = cal1.getTime();	// 청구일자(1일)
			Date feeChargedate = cal2.getTime(); // 납부기준일(15일)
			Date nowDate = now1.getTime();	// 오늘 날짜
			
			// 총 청구금액
			headCharge = (frcsAmt + frcsRowal + orderAmt+ tradAdd) - tradRedct;	
			
			feeVO.setFeeChargedate(feeChargedate);
			feeVO.setFrcsId(frcsId);

			// 가맹비 총괄 테이블에 데이터가 존재하는지 체크
			int duplicationCheck = billMapper.dupliCheck(feeVO);

			if(duplicationCheck>0) {
				billVO.setSettleAt("Y");	// 데이터가 존재하면 납부를 한거기때문에 납부상태 Y로 변경
				
				Date settleDate = billMapper.getSettleDate(feeVO);
				billVO.setSettleDate(settleDate);
				
				if(settleDate.compareTo(feeDday) >=0 && settleDate.compareTo(feeChargedate) <=0) {
					billVO.setFrcsbillOverdue(0);
				}
				
				// 오늘날짜가 청구일자와 같거나 크면서 납부 기준일보다 크면 이자 발생
				if(settleDate.compareTo(feeDday) >=0 && settleDate.compareTo(feeChargedate) > 0) {

					// 첫 한달은 1% 이자 발생
					int overdue = (int) (headCharge * 0.01);
					
					// 오늘날짜가 납부 기준일보다 2달 이상 지났으면 3% 이자 발생
					billVO.setFrcsbillOverdue(overdue);
					
					headCharge = (frcsAmt + frcsRowal + orderAmt+ tradAdd) - tradRedct + overdue;
				}
			}else {
				
				// 오늘날짜가 청구일자와 같거나 크면서 납부 기준일보다 같거나 작으면 이자 발생 x
				if(nowDate.compareTo(feeDday) >=0 && nowDate.compareTo(feeChargedate) <=0) {
					billVO.setFrcsbillOverdue(0);
				}
				
				// 오늘날짜가 청구일자와 같거나 크면서 납부 기준일보다 크면 이자 발생
				if(nowDate.compareTo(feeDday) >=0 && nowDate.compareTo(feeChargedate) > 0) {

					// 첫 한달은 1% 이자 발생
					int overdue = (int) (headCharge * 0.01);
					
					// 오늘날짜가 납부 기준일보다 2달 이상 지났으면 3% 이자 발생
					billVO.setFrcsbillOverdue(overdue);
					
					headCharge = (frcsAmt + frcsRowal + orderAmt+ tradAdd) - tradRedct + overdue;
				}
			}
			
			// 인건비
			int pay = operationVO.getPay();
			
			// 공과금 및 월세
			int publicDues = mapper.getSumPublicDues(frcsId, thisMonth);
			
			// 영업이익
			int operationProfit = sales-(headCharge+publicDues+pay+publicDues);
			
			// 당기 순이익
			double currentIncome = operationProfit - (operationProfit * 0.01);
			int currentIncomeInt = (int) currentIncome;
			
			// 오늘 날짜 체크해서 그 다음 달들은 차트 0으로 뜨게끔
			if(thisMonth.after(nowDate)) {
				operationVO.setCurrentIncome(0);
			}else {
				operationVO.setCurrentIncome(currentIncomeInt);
			}
			
			monthsList.add(operationVO);
		}
		
		return monthsList;
		
	}
}
