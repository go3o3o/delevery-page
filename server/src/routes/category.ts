import * as express from 'express';

import { getConnectionManager } from 'typeorm';

import { Store } from '../entities/Store';

const router = express.Router();

// 0: 한식, 1: 중식, 2: 분식, 3: 치킨, 4: 피자, 5: 패스트푸드, 6: 일식, 7: 양식, 8: 보쌈|족발, 9: 야식
router.get('/:category', async (req, res) => {
  const category = req.params.category;

  const manager = getConnectionManager().get('delivery');
  const repository = manager.getRepository(Store).createQueryBuilder();

  try {
    const stores = await repository.where('category = :category', { category }).getMany();

    return res.json({ data: stores });
  } catch (e) {
    return res.status(500).json({ msg: e.message });
  }
});

export default router;
