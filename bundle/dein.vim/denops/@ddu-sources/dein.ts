import {
  BaseSource,
  Item,
} from "https://deno.land/x/ddu_vim@v0.8.0/types.ts";
import { Denops } from "https://deno.land/x/ddu_vim@v0.8.0/deps.ts";
import { ActionData } from "https://deno.land/x/ddu_kind_file@v0.2.0/file.ts";

type Params = Record<string, never>;

type Dein = {
  name: string;
  path: string;
};

export class Source extends BaseSource<Params> {
  kind = "file";

  gather(args: {
    denops: Denops;
    sourceParams: Params;
  }): ReadableStream<Item<ActionData>[]> {
    return new ReadableStream({
      async start(controller) {
        const deins = Object.values(
          await args.denops.call("dein#get") as Record<string, Dein>,
        );
        const items = deins.map((dein) => {
          return {
            word: dein.name,
            action: {
              path: dein.path,
            },
          };
        });

        controller.enqueue(items);

        controller.close();
      },
    });
  }

  params(): Params {
    return {};
  }
}
