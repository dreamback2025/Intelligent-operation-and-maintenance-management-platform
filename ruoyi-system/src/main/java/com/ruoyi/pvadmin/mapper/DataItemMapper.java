package com.ruoyi.pvadmin.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.ruoyi.pvadmin.domain.entity.DataItem;
import com.ruoyi.pvadmin.domain.model.ElectricModel;
import java.util.List;

/**
 * 累积量  Mapper接口
 */
public interface DataItemMapper extends BaseMapper<DataItem> {

    List<DataItem> listDataItemByDeviceIds(ElectricModel model);
}